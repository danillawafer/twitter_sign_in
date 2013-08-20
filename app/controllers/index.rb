get '/' do
  erb :index
end

get '/sign_in' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  redirect request_token.authorize_url
end

get '/sign_out' do
  session.clear
  redirect '/'
end

get '/auth' do
  # the `request_token` method is defined in `app/helpers/oauth.rb`
  @access_token = request_token.get_access_token(:oauth_verifier => params[:oauth_verifier])
  # our request token is only valid until we use it to get an access token, so let's delete it from our session
  session.delete(:request_token)

  find_user

  session[:user_token] = @user.oauth_token
  session[:user_secret] = @user.oauth_secret

  erb :index 
end

post '/tweet' do
  @tweet = params[:tweet]
  @user = User.where(oauth_token: session[:user_token], oauth_secret: session[:user_secret]).first
  make_the_tweet
  redirect '/tweeted'
end

get '/tweeted' do
  erb :successful_tweet
end
  