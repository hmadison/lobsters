json.type 'Document'
json.id story_url(story, domain: Rails.application.domain)
json.name story.title
json.url story_url(story, domain: Rails.application.domain)

json.tag(story.tags) do |tag|
  json.type 'Note'
  json.id tag_url(tag, domain: Rails.application.domain)
  json.name tag.tag
  json.content tag.description
end

json.attributedTo do
  json.partial! story.user
end
