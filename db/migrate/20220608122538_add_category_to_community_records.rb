class AddCategoryToCommunityRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :community_records, :category, :string
    add_column :community_records, :tags, :text
  end
end
