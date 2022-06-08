class AddLanguageToCommunityRecords < ActiveRecord::Migration[6.0]
  def change
    add_column :community_records, :language, :string
  end
end
