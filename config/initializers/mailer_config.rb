Payments::Application.configure do
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings   = {
    :address              => 'smtp.gmail.com',
    :domain               => 'gmail.com',
    :port                 => 587,
    :user_name            => 'ktoolroom@gmail.com',
    :password             => 'biscuits00',
    :authentication       => :plain,
    :enable_starttls_auto => true
  }
  config.action_mailer.raise_delivery_errors = true
end
