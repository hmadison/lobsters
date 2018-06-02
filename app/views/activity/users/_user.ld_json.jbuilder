json.type 'Person'
json.id activity_user_url(user.username, domain: Rails.application.domain)
json.name user.username
