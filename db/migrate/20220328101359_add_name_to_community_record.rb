class AddNameToCommunityRecord < ActiveRecord::Migration[6.0]
  def change
    add_column :community_records, :name, :text
  end
end
