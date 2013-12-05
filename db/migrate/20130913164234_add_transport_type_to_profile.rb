class AddTransportTypeToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :transport_type, :string
  end
end
