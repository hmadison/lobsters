class Activity::UsersController < ApplicationController
  PAGE_SIZE = 25
  skip_before_action :verify_authenticity_token, only: %i(inbox outbox)

  before_action :find_user

  before_action :doorkeeper_authorize!, only: %i(inbox)
  before_action :doorkeeper_authorize!, only: %i(outbox), if: -> { true }

  def show
    respond_to do |format|
      format.ld_json { render :show }
    end
  end

  def inbox
    @stream_total = Activity::InboxStream.for_user(@user.id).count

    @page = Integer(params[:page] || 1)
    @term = if @page == 1
              'first'
            elsif (@stream_total - (@page * PAGE_SIZE)) < PAGE_SIZE
              'last'
            else
              'current'
            end

    @slice = Activity::InboxStream.for_user(@user.id).offset((@page - 1) * PAGE_SIZE).limit(PAGE_SIZE)

    respond_to do |format|
      format.ld_json { render :inbox }
    end
  end

  def outbox
    case params['Type']
    when false
      head :bad_request
    else
      head :bad_request
    end
  end

  private

  def find_user
    @user = User.find_by(username: params[:id])
  end
end
