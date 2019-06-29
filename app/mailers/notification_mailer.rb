class NotificationMailer < ActionMailer::Base
  default from: ENV['SEND_MAIL_ADRESS']

# エラーか予約失敗かでタイトルを分けるかどうかは要検討
  def send_reseve_fail(error)
    @error = error
    @researchs = Research.recent_left_bikes
    mail(
      subject: "予約が失敗しました", #メールのタイトル
      to: ENV['TO_MAIL_ADRESS'] #宛先
    ) do |format|
      format.text
    end
  end
end
