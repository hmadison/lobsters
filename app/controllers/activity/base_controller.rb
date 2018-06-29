class Activity::BaseController < ApplicationController
  def default_url_options
    { host: Rails.application.domain }
  end
end
