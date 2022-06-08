class Record < ApplicationRecord
  def load_xml_data
    raise "Abstract Method"
  end

  def convert_to_json(hash_data)
    hash_data.to_json
  end

  def convert_xml_to_hash
    raise "Abstract Method"
  end

  def geo_location_input(latitude, longitude)
    {
      latitude: latitude.to_f,
      longitude: longitude.to_f
    }
  end

  def is_true?(value)
    [1, true, '1', 'true', 't'].include?(value)
  end

  def select_target_servers(location, potential_target_servers)
    # Bei BBNavi werden alle Standorte importiert
    selected_servers = potential_target_servers

    selected_servers.try(:keys)
  end

  def store_locations(location, import_type)
    Resource.where(title: location[:district], type: 'district', import_type: import_type).first_or_create if location[:district].present?
    Resource.where(title: location[:department], type: 'department', import_type: import_type).first_or_create if location[:department].present?
    Resource.where(title: location[:region_name], type: 'region', import_type: import_type).first_or_create if location[:region_name].present?
    Resource.where(title: location[:name], type: 'location', import_type: import_type).first_or_create if location[:name].present?
  end

end

# == Schema Information
#
# Table name: records
#
#  id          :bigint           not null, primary key
#  external_id :string
#  json_data   :jsonb
#  xml_data    :text
#  type        :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
