class CreateActivityOutboxStreams < ActiveRecord::Migration[5.1]
  def change
    create_view :activity_outbox_streams
  end
end
