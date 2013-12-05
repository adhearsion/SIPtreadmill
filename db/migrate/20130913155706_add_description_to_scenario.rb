class AddDescriptionToScenario < ActiveRecord::Migration
  def change
    add_column :scenarios, :description, :text
  end
end
