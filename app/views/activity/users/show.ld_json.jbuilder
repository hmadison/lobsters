json.set! :'@context', 'https://www.w3.org/ns/activitystreams'

json.type 'Person'
json.name @user.username
json.id user_url(@user)

json.inbox inbox_activity_user_url(@user)
json.outbox outbox_activity_user_url(@user)

json.endpoints do
  json.oauthAuthorizationEndpoint oauth_authorization_url
  json.oauthTokenEndpoint oauth_token_url
end
