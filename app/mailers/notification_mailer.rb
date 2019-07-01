class NotificationMailer < ActionMailer::Base
  default from: ENV['SEND_MAIL_ADRESS']

  def send_has_bike_ports
    @researchs = Research.recent_left_bikes
    subject = @researchs.blank? ? "予約可能な自転車はありませんでした" : "予約可能ポート一覧です"
      mail(
        subject: subject, #メールのタイトル
        to: ENV['TO_MAIL_ADRESS'] #宛先
      ) do |format|
        format.text
      end
  end
end
