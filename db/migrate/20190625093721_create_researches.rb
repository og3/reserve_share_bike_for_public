class CreateResearches < ActiveRecord::Migration[5.0]
  def change
    create_table :researches do |t|
      t.string :port_name
      t.integer :reft_bikes
      t.datetime :research_at
      t.integer :research_wday
      t.string :weather
      t.timestamps
    end
  end
end
