
typedef std::map<std::string, std::string> HTTPParameters;

std::string OAuthWebRequestSubmit( 
    const std::string& url, 
	const std::string& httpMethod, 
	const HTTPParameters* postParameters,
    const std::string& consumerKey, 
    const std::string& consumerSecret, 
    const std::string& oauthToken = "", 
    const std::string& oauthTokenSecret = "", 
    const std::string& pin = ""
    );

std::string UrlEncode( const std::string& url );
HTTPParameters ParseQueryString(const std::string &url);