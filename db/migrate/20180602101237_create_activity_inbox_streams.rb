class CreateActivityInboxStreams < ActiveRecord::Migration[5.1]
  def change
    create_view :activity_inbox_streams
  end
end
