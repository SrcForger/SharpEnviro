#define DLLEXPORT __declspec(dllexport)

// Exports
extern "C" DLLEXPORT int twitterAuthorize(char *token, char *tokenSecret, char *screenName);
extern "C" DLLEXPORT int twitterLoadPin();
extern "C" DLLEXPORT int twitterVerifyPin(char *pin);

extern "C" DLLEXPORT int twitterUpdateStatus(char *newStatus);

extern "C" DLLEXPORT int twitterGetTimeLine(char *&timeline, int getlen);

extern "C" DLLEXPORT int twitterGetTokenData(char *token, char *tokenSecret, char *name);

// Twitter wrapper class
class Twitter
{
public:
	Twitter();
	~Twitter();

	bool Authorize(std::string token, std::string tokenSecret, std::string name);
	bool LoadPin();
	bool VerifyPin(std::string pin);
	
	bool GetHomeTimeLine(std::string &userTimeLine);

	bool UpdateStatus(std::string newStatus);

	std::string getToken();
	std::string getTokenSecret();
	std::string getScreenName();

private:
	std::string oauthRequestToken, oauthRequestTokenSecret;
	std::string oauthAccessToken, oauthAccessTokenSecret, screenName;

};