Vhpanel::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request.  This slows down response time but is perfect for development
  # since you don't have to restart the webserver when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_view.debug_rjs             = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin
  ActionMailer::Base.smtp_settings = {
      :enable_starttls_auto => true,
      :address => "smtp.gmail.com",
      :port => 587,
      :authentication => :plain,
      :user_name => "jm@idifysolutions.com",
      :password => "dl6cd1357"
  }

  require 'Bluepay'
  BP_ACCOUNT_ID = '100055017580'
  BP_SECRET_KEY = 'X403IXYR3M2Q2DNEZQ56CWOOF4XMOJQK'
  
  PP_LOGIN    = 'deepak_1321945032_biz_api1.idifysolutions.com'
  PP_PASSWORD = '1321945056'
  PP_SIGNATURE= 'AiV5rpT79mrM-pI474-2v7GmpP9LAwPTcSESFxkXpua2cBBWhqw4ieph' 
  config.after_initialize do
    ActiveMerchant::Billing::Base.mode = :test
  end

end

