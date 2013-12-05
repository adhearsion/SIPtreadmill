class AddCsvDataToScenario < ActiveRecord::Migration
  def change
    add_column :scenarios, :csv_data, :text
  end
end
