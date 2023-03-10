class Importer
  attr_accessor :access_token, :record_type
  class << self

    # load data and send it to all servers
    def perform(record_type)
      Importer.load_data(record_type)
      Importer.parse_data(record_type)
      Importer.send_data(record_type)
    end

    # load data without sending it to all servers
    def update_data(record_type)
      Importer.load_data(record_type)
      Importer.parse_data(record_type)
    end

    def load_data(record_type)
      p "Start loading #{record_type}"
      record = record_model(record_type)
      record.destroy_all

      record.new.load_xml_data
    end

    def parse_data(record_type)
      p "Start parsing #{record_type}"
      CommunityRecord.where(data_type: record_type.to_s).delete_all
      p "...cleaned up old #{record_type} data"

      record = record_model(record_type)
      record.last.parse_data
    end

    def send_data(record_type)
      CommunityRecord.where.not(title: "unused").pluck(:title).uniq.each do |target_server_name|
        p "Sending Server: #{target_server_name}"
        Importer.delay.send_data_to_community(record_type, target_server_name)
      end
    end

    def send_data_to_community(record_type, community_name)
      options = Rails.application.credentials.target_servers[community_name.to_sym]
      access_token = Authentication.new(community_name, options).access_token
      CommunityRecord.where.not(title: "unused").where(data_type: record_type.to_s, title: community_name).each_with_index do |record, index|
        begin
          data_to_send = record.json_data
          next if record.json_data["tours"].present?

          if index % 1000 == 0
            sleep 60
            access_token = Authentication.new(name, options).access_token
          end

          send_json_to_server(community_name, options, data_to_send, access_token)

        rescue => e
          p "Error: #{e.message} - Server #{community_name} - ID #{record.id}"
        end
      end
    end

    def record_model(record_type)
      case record_type
      when :poi
        PoiRecord
      when :event
        EventRecord
      end
    end

    def send_json_to_server(name, options, data_to_send, access_token)
      begin
        url = options[:target_server][:url]

        puts "Sending data to #{name}"

        ApiRequestService.new(url, nil, nil, data_to_send, { Authorization: "Bearer #{access_token}" }).post_request
      rescue => e
        p "Error on sending to #{name}: #{e}"
      end
    end
  end
end
