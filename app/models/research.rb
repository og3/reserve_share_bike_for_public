class Research < ApplicationRecord
  def self.recent_left_bikes
    @researchs = Research.where(research_at: Research.last.research_at).where('reft_bikes > 0')
  end
end
