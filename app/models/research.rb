class Research < ApplicationRecord
  # NotificationMailer内のメソッドで呼び出すためにselfにしている
  def self.recent_left_bikes
    researchs = Research.where(research_at: Research.last.research_at)
  end
end
