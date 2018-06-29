class Activity::UsersController < Activity::BaseController
  PAGE_SIZE = 25
  skip_before_action :verify_authenticity_token, only: %i(inbox outbox)

  before_action :find_user
  before_action :doorkeeper_authorize!, if: -> { (request.post? && action_name == 'outbox') || (action_name == 'inbox') }

  def show
    respond_to do |format|
      format.ld_json { render :show }
    end
  end

  def inbox
    unless current_resource_owner.id == @user.id
      head 401 && return
    end

    show_stream(Activity::InboxStream, method(:inbox_activity_user_url))
  end

  def outbox
    show_stream(Activity::OutboxStream, method(:outbox_activity_user_url))
  end

  private

  def show_stream(klass, url_method)
    @url_method = url_method
    @stream_total = klass.for_user(@user.id).count

    @page = Integer(params[:page] || 1)
    @term = if @page == 1
              'first'
            elsif (@stream_total - (@page * PAGE_SIZE)) < PAGE_SIZE
              'last'
            else
              'current'
            end

    @slice = klass.for_user(@user.id).offset((@page - 1) * PAGE_SIZE).limit(PAGE_SIZE)

    respond_to do |format|
      format.ld_json { render :stream }
    end
  end

  def current_resource_owner
    User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def find_user
    @user = User.find_by(username: params[:id])
  end
end
