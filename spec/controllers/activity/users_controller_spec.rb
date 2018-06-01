require 'rails_helper'

RSpec.describe Activity::UsersController, type: :controller do
  render_views

  # All interactions with this controller should be ld+json
  before :each do
    request.env["HTTP_ACCEPT"] = 'application/ld+json'
  end

  let!(:user) { User.make!(username: 'sample_user') }

  context '#show' do
    let(:user_id) { user_url(user, domain: Rails.application.domain) }
    let(:user_inbox) { inbox_activity_user_url(user, domain: Rails.application.domain) }
    let(:user_outbox) { outbox_activity_user_url(user, domain: Rails.application.domain) }

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
end
