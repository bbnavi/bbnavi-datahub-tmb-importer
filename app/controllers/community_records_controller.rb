class CommunityRecordsController < ApplicationController

  # GET /community_records
  def index
    @community_records = CommunityRecord.all
    @communities = CommunityRecord.where.not(title: "unused").pluck(:title).uniq
  end

  def show
    @community_record = CommunityRecord.find(params[:id])
  end

  def import
    import_type = (params[:import_type] || "poi").to_sym
    Importer.delay.update_data(import_type)
    redirect_to community_records_path, notice: "Import started"
  end

  def send_data
    import_type = params[:import_type] || "poi"
    community_name = params[:community_name]
    Importer.delay.send_data_to_community(import_type, community_name) if community_name.present?

    redirect_to community_records_path, notice: "Sending #{import_type} data to #{community_name} server"
  end

  def send_single_data
    community_record = CommunityRecord.find(params[:id])
    unless community_record.title == "unused"
      options = ReleaseSettings.target_servers[community_record.title.to_sym]
      Importer.delay.send_json_to_server(community_record.title, options, community_record.json_data)
    end
    redirect_to community_record_path(community_record), notice: "Sending data to #{community_record.title} server"
  end

end
