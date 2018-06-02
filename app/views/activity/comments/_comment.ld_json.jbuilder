json.type 'Note'
json.id comment_url(comment.short_id, domain: Rails.application.domain)
json.name "Story Comment"
json.content comment.comment

json.inReplyTo (if comment.parent_comment_id
                comment_url(comment.parent_comment.short_id, domain: Rails.application.domain)
               else
                 story_url(comment.story, domain: Rails.application.domain)
                end)

json.attributedTo do
  json.partial! comment.user
end
