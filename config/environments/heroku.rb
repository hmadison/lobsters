require_relative 'production'

Lobsters::Application.config.secret_key_base = ENV['SECRET_KEY_BASE']

class << Rails.application
  def domain
    ENV['SITE_DOMAIN']
  end

  def name
    ENV['SITE_NAME']
  end
end

Rails.application.routes.default_url_options[:host] = Rails.application.domain

# Expose mailgun smtp options
mailgun_keys = ENV.keys.select { |k| k ~= /^mailgun/i }
mailgun_keys.map { |k| k.sub('MAILGUN_') }.each { |k| ENV[k] = ENV['MAILGUN_' + k] }
