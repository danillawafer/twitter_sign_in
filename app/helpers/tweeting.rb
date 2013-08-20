def make_the_tweet
	client = Twitter.configure do |config|
    config.oauth_token = @user.oauth_token
    config.oauth_token_secret = @user.oauth_secret
  end
    client.update(@tweet)
end