json.type 'Note'
json.id message_url(message.short_id, domain: Rails.application.domain)
json.name message.subject
json.content message.body

json.attributedTo do
  json.partial! message.author
end
