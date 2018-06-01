class Activity::UsersController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i(inbox outbox)

  def show
    @user = User.find_by(username: params[:id])

    respond_to do |format|
      format.ld_json { render :show }
    end
  end

  def inbox
  end

  def outbox
    case params['Type']
    when false
      head :bad_request
    else
      head :bad_request
    end
  end
end
