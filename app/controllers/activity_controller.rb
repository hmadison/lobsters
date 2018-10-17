class ActivityController < ApplicationController
  before_action :find_subject

  def inbox
  end

  def outbox
  end

  private

  def find_subject
    @subject = GlobalID::Locator.locate(params[:id])
  end
end
