json.set! :'@context', 'https://www.w3.org/ns/activitystreams'

json.type 'Person'
json.name @showing_user.username
json.id user_url(@showing_user)

json.inbox inbox_activity_path(@showing_user.to_global_id)
json.outbox outbox_activity_path(@showing_user.to_global_id)

json.endpoints do
  json.oauthAuthorizationEndpoint 'pending' #oauth_authorization_url
  json.oauthTokenEndpoint 'pending' #oauth_token_url
end
