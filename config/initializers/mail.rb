# 今後はメールが飛ぶのは本番環境のみにする
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
  address: 'smtp.gmail.com',
  domain: 'gmail.com',
  port: 587,
  user_name: ENV['SEND_MAIL_ADRESS'],
  password: ENV['SEND_MAIL_ADRESS_PASS'],
  authentication: 'plain',
  enable_starttls_auto: true
}
