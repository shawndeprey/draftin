# Load the Rails application.
require File.expand_path('../application', __FILE__)

# Initialize the Rails application.
Draftin::Application.initialize!

Draftin::Application.config.action_mailer.delivery_method = :smtp
ActionMailer::Base.smtp_settings = YAML.load_file(
    Rails.root.join('config', 'mailers.yml'))[Rails.env].try(:to_options)