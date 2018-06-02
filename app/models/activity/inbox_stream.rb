class Activity::InboxStream < ApplicationRecord
  belongs_to :streamable, polymorphic: true

  scope :for_user, ->(user_id) do
    where(user_id: [nil, user_id]).
      distinct.
      not_hidden_by(user_id).
      not_filterd_by(user_id).
      order(created_at: :desc)
  end

  scope :not_hidden_by, ->(user_id) do
    joins("LEFT OUTER JOIN hidden_stories ON hidden_stories.story_id = activity_inbox_streams.streamable_id AND activity_inbox_streams.streamable_type = 'Story' AND hidden_stories.user_id = ", user_id.to_s)
      .where('hidden_stories.id is NULL')
  end

  scope :not_filterd_by, ->(user_id) do
    joins("LEFT OUTER JOIN taggings ON activity_inbox_streams.streamable_type = 'Story' AND taggings.story_id = activity_inbox_streams.streamable_id").
      joins("LEFT OUTER JOIN tag_filters ON tag_filters.tag_id = taggings.tag_id AND tag_filters.user_id", user_id.to_s).
      where('tag_filters.id is NULL')
  end

  protected
  # This is a view, not a real table
  def readonly?
    true
  end
end
