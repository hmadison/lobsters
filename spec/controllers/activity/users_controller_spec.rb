require 'rails_helper'

RSpec.describe Activity::UsersController, type: :controller do
  render_views

  let!(:user) { User.make!(username: 'sample_user') }
  let!(:api_token) { Doorkeeper::AccessToken.make!(resource_owner_id: user.id) }

  # All interactions with this controller should be ld+json
  before :each do
    request.env["HTTP_ACCEPT"] = 'application/ld+json'
    request.env["HTTP_AUTHORIZATION"] = "Bearer #{api_token.token}"
  end

  let(:user_id) { user_url(user, domain: Rails.application.domain) }
  let(:user_inbox) { inbox_activity_user_url(user, domain: Rails.application.domain) }
  let(:user_outbox) { outbox_activity_user_url(user, domain: Rails.application.domain) }

  context '#show' do
    it 'generates a profile object for a user' do
      get :show, params: {id: user.username}

      expect(response.content_type).to eq('application/ld+json')

      expect(response.body).to define_ld_property('type', 'Person')
      expect(response.body).to define_ld_property('name', user.username)
      expect(response.body).to define_ld_property('id', user_id)

      expect(response.body).to define_ld_property('inbox', user_inbox)
      expect(response.body).to define_ld_property('outbox', user_outbox)
    end
  end

  context '#inbox' do
    # Set up the data to make a fake stream
    let!(:story) { Story.make!(user_id: user.id) }
    let!(:comment) { Comment.make!(story_id: story.id) }
    let!(:message) { Message.make!(recipient_user_id: user.id) }

    before do
      ReadRibbon.create(story_id: comment.story.id, user_id: user.id, updated_at: 1.year.ago)
    end

    it 'generates an inbox stream for a user' do
      get :inbox, params: {id: user.username}

      expect(response.content_type).to eq('application/ld+json')

      expect(response.body).to define_ld_property('type', 'OrderedCollection')
      expect(response.body).to define_ld_property('id', user_inbox)
      expect(response.body).to define_ld_property('toatlItems', 3)
    end
  end


  context '#outbox' do
    # Set up the data to make a fake stream
    let!(:story) { Story.make!(user_id: user.id) }
    let!(:comment) { Comment.make!(story_id: story.id) }

    it 'generates an inbox stream for a user' do
      get :outbox, params: {id: user.username}

      expect(response.content_type).to eq('application/ld+json')

      expect(response.body).to define_ld_property('type', 'OrderedCollection')
      expect(response.body).to define_ld_property('id', user_outbox)
      expect(response.body).to define_ld_property('toatlItems', 2)
    end
  end
end
