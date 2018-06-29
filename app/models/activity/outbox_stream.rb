class Activity::OutboxStream < ApplicationRecord
  belongs_to :streamable, polymorphic: true

  scope :for_user, ->(user_id) { where(user_id: user_id).distinct.order(created_at: :desc) }

  protected
  # This is a view, not a real table
  def readonly?
    true
  end
end
