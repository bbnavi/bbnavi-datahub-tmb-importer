class AddImporttypeToResources < ActiveRecord::Migration[6.0]
  def change
    add_column :resources, :import_type, :string
  end
end
