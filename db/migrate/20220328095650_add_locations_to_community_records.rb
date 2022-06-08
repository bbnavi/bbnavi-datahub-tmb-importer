class AddLocationsToCommunityRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :community_records, :location_name, :string
    add_column :community_records, :department, :string
    add_column :community_records, :district, :string
    add_column :community_records, :region_name, :string
  end
end
