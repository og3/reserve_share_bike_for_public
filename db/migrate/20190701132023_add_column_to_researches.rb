class AddColumnToResearches < ActiveRecord::Migration[5.0]
  def change
    add_column :researches, :port_code, :string
  end
end
