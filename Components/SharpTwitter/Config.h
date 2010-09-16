#ifndef TWITTER_CONFIG_H
#define TWITTER_CONFIG_H

const char ConsumerKey[] = {"PUjSNqkUU0uB5YkfSjUHg"};
const char ConsumerSecret[] = {"roeh8eIuxmxGTg4vFYXSAABg11YQK8ugYS9YuOak2w"};

const char HostName[] = {"http://twitter.com"};
const char AuthenticateUrl[] = {"http://twitter.com/oauth/authenticate"};
const char AccessUrl[] = {"http://twitter.com/oauth/access_token"};
const char AuthorizeUrl[] = {"http://twitter.com/oauth/authorize?oauth_token=%s"};
const char RequestUrl[] = {"http://twitter.com/oauth/request_token"}; 
const char HomeTimelineUrl[] = {"http://twitter.com/statuses/home_timeline.xml"};
const char UserTimelineUrl[] = {"http://twitter.com/statuses/user_timeline.xml"};
const char UserStatusUpdateUrl[] = {"http://twitter.com/statuses/update.xml"};
const char VerifyCredentials[] = {"http://twitter.com/account/verify_credentials.xml"};

#endif