account = Settings.twitter

$twitter = Twitter::REST::Client.new do |config|
  config.consumer_key = account.consumer_key
  config.consumer_secret = account.consumer_secret
  config.access_token = account.oauth_token
  config.access_token_secret = account.oauth_token_secret
end