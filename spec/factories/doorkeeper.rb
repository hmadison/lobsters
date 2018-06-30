FactoryBot.define do
  factory :doorkeeper_application, class: Doorkeeper::Application do
    name { "OAuth App" }
    scopes { "public" }
    redirect_uri { "urn:ietf:wg:oauth:2.0:oob" }
  end

  factory :doorkeeper_access_token, class: Doorkeeper::AccessToken do
    application_id { create(:doorkeeper_application).id }
    resource_owner_id { nil }
    expires_in { 2.hours }
    scopes { "public" }
  end
end
