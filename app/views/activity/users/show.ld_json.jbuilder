json.set! :'@context', 'https://www.w3.org/ns/activitystreams'

json.type 'Person'
json.name @user.username
json.id user_url(@user, domain: Rails.application.domain)

json.inbox inbox_activity_user_url(@user, domain: Rails.application.domain)
json.outbox outbox_activity_user_url(@user, domain: Rails.application.domain)

json.endpoints do
  json.oauthAuthorizationEndpoint oauth_authorization_url(domain: Rails.application.domain)
  json.oauthTokenEndpoint oauth_token_url(domain: Rails.application.domain)
end
