#include <string>
#include <map>
#include <Windows.h>
#include "Config.h"
#include "SharpTwitter.h"
#include "twitter.h"

Twitter *twitter = NULL;

BOOL APIENTRY DllMain( HMODULE hModule,
                       DWORD  ul_reason_for_call,
                       LPVOID lpReserved
					 )
{
	return TRUE;
}


extern "C" DLLEXPORT int twitterAuthorize(char *token, char *tokenSecret, char *screenName)
{
	if(twitter)
		delete twitter;
	twitter = NULL;

	twitter = new Twitter();
	if(!twitter->Authorize(token, tokenSecret, screenName))
		return 0;

	return 1;
}

extern "C" DLLEXPORT int twitterLoadPin()
{
	if(!twitter)
		return 0;

	return twitter->LoadPin();
}

extern "C" DLLEXPORT int twitterVerifyPin(char *pin)
{
	if(!twitter)
		return 0;

	return twitter->VerifyPin(pin);
}

extern "C" DLLEXPORT int twitterUpdateStatus(char *newStatus)
{
	if(!twitter)
		return 0;

	return int(twitter->UpdateStatus(newStatus));
}

extern "C" DLLEXPORT int twitterGetTimeLine(char *&timeline, int getlen)
{
	if(!twitter)
		return 0;

	std::string line;
	twitter->GetHomeTimeLine(line);

	if(getlen)
		return line.length();

	strcpy_s(timeline, line.length() + 1, line.c_str());

	return line.length();
}

extern "C" DLLEXPORT int twitterGetTokenData(char *token, char *tokenSecret, char *name)
{
	if(!twitter)
		return 0;

	strcpy_s(token, 256, twitter->getToken().c_str());
	strcpy_s(tokenSecret, 256, twitter->getTokenSecret().c_str());
	strcpy_s(name, 256, twitter->getScreenName().c_str());

	return 1;
}

Twitter::Twitter()
{
	oauthRequestToken = oauthRequestTokenSecret = "";
	oauthAccessToken = oauthAccessTokenSecret = screenName = "";
}

Twitter::~Twitter()
{

}

bool Twitter::Authorize(std::string token, std::string tokenSecret, std::string name)
{
	oauthAccessToken = token;
	oauthAccessTokenSecret = tokenSecret;

	if( oauthAccessToken.empty() || oauthAccessTokenSecret.empty())
		return false;

	std::string ret = OAuthWebRequestSubmit(VerifyCredentials, "GET", NULL, ConsumerKey, ConsumerSecret, 
		oauthAccessToken, oauthAccessTokenSecret);

	if(ret.find("<error>") != std::string::npos)
		return false;

	return true;
}

bool Twitter::LoadPin()
{
	// Overall OAuth flow based on 
	// Professional Twitter Development: With Examples in .NET 3.5 by Daniel Crenna
	std::string requestToken = OAuthWebRequestSubmit(RequestUrl, "GET", NULL, ConsumerKey, ConsumerSecret);

	HTTPParameters response = ParseQueryString(requestToken);
	oauthRequestToken = response["oauth_token"];
	oauthRequestTokenSecret = response["oauth_token_secret"];
	if(!oauthRequestToken.empty())
	{
		char buf[1024] = {};
		sprintf_s(buf, sizeof(buf), AuthorizeUrl, oauthRequestToken.c_str());

		ShellExecute(NULL, "open", buf, NULL, NULL, SW_SHOWNORMAL);
	}

	return true;
}

bool Twitter::VerifyPin(std::string pin)
{
	// exchange the request token for an access token
	std::string accessTokenString = OAuthWebRequestSubmit(AccessUrl, "GET", NULL, ConsumerKey, ConsumerSecret, 
		oauthRequestToken, oauthRequestTokenSecret, pin);

	if(accessTokenString.find("<error>") != std::string::npos)
		return false;

	HTTPParameters accessTokenParameters = ParseQueryString(accessTokenString);
	oauthAccessToken = accessTokenParameters["oauth_token"];
	oauthAccessTokenSecret = accessTokenParameters["oauth_token_secret"];
	screenName = accessTokenParameters["screen_name"];

	return true;
}

bool Twitter::GetHomeTimeLine(std::string &userTimeLine)
{
	std::string ret = OAuthWebRequestSubmit(HomeTimelineUrl, "GET", NULL, ConsumerKey, ConsumerSecret, 
		oauthAccessToken, oauthAccessTokenSecret);

	if(ret.find("<error>") != std::string::npos)
		return false;

	userTimeLine = ret;

	return true;
}

bool Twitter::UpdateStatus(std::string newStatus)
{
	HTTPParameters postParams;
	postParams["status"] = UrlEncode(newStatus);

	std::string ret = OAuthWebRequestSubmit(UserStatusUpdateUrl, "POST", &postParams, ConsumerKey, ConsumerSecret, 
			oauthAccessToken, oauthAccessTokenSecret);

	if(ret.find("<error>") != std::string::npos)
		return false;

	return true;
}

std::string Twitter::getToken()
{
	return oauthAccessToken;
}

std::string Twitter::getTokenSecret()
{
	return oauthAccessTokenSecret;
}

std::string Twitter::getScreenName()
{
	return screenName;
}
