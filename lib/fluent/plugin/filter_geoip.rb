require 'maxminddb'
require 'json'
require 'fileutils'
require 'open-uri'

module Fluent
  class GeoIPFilter < Filter
    Fluent::Plugin.register_filter('geoip', self)

    DEFAULT_ENABLE_DOWNLOAD = true
    DEFAULT_MD5_URL = 'http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.md5'
    DEFAULT_DOWNLOAD_URL = 'http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz'
    DEFAULT_MD5_PATH = './geoip/database/GeoLite2-City.md5'
    DEFAULT_DATABASE_PATH = './geoip/database/GeoLite2-City.mmdb'

    DEFAULT_LOOKUP_FIELD = 'ip'
    DEFAULT_OUTPU_FIELD = 'geoip'
    DEFAULT_FIELD_DELIMITER = '.'
    DEFAULT_FLATTEN = false

    DEFAULT_LOCALE = 'en'

    DEFAULT_CITY = true
    DEFAULT_CONTINENT = true
    DEFAULT_COUNTRY = true
    DEFAULT_LOCATION = true
    DEFAULT_POSTAL = true
    DEFAULT_REGISTERED_COUNTRY = true
    DEFAULT_REPRESENTED_COUNTRY = true
    DEFAULT_SUBDIVISIONS = true
    DEFAULT_TRAITS = true
    DEFAULT_CONNECTION_TYPE = true

    config_param :enable_auto_download, :string, :default => DEFAULT_ENABLE_DOWNLOAD,
                 :desc => ''

    config_param :md5_path, :string, :default => DEFAULT_MD5_PATH,
                 :desc => ''

    config_param :md5_url, :string, :default => DEFAULT_MD5_URL,
                 :desc => ''

    config_param :download_url, :string, :default => DEFAULT_DOWNLOAD_URL,
                 :desc => ''

    config_param :database_path, :string, :default => DEFAULT_DATABASE_PATH,
                 :desc => ''

    config_param :lookup_field, :string, :default => DEFAULT_LOOKUP_FIELD,
                 :desc => ''

    config_param :output_field, :string, :default => DEFAULT_OUTPU_FIELD,
                 :desc => ''

    config_param :field_delimiter, :string, :default => DEFAULT_FIELD_DELIMITER,
                 :desc => ''

    config_param :flatten, :bool, :default => DEFAULT_FLATTEN,
                 :desc => ''

    config_param :locale, :string, :default => DEFAULT_LOCALE,
                 :desc => ''

    config_param :continent, :bool, :default => DEFAULT_CONTINENT,
                 :desc => ''

    config_param :country, :bool, :default => DEFAULT_COUNTRY,
                 :desc => ''

    config_param :city, :bool, :default => DEFAULT_CITY,
                 :desc => ''

    config_param :location, :bool, :default => DEFAULT_LOCATION,
                 :desc => ''

    config_param :postal, :bool, :default => DEFAULT_POSTAL,
                 :desc => ''

    config_param :registered_country, :bool, :default => DEFAULT_REGISTERED_COUNTRY,
                 :desc => ''

    config_param :represented_country, :bool, :default => DEFAULT_REPRESENTED_COUNTRY,
                 :desc => ''

    config_param :subdivisions, :bool, :default => DEFAULT_SUBDIVISIONS,
                 :desc => ''

    config_param :traits, :bool, :default => DEFAULT_TRAITS,
                 :desc => ''

    config_param :connection_type, :bool, :default => DEFAULT_CONNECTION_TYPE,
                 :desc => ''

    def initialize
      super
    end

    def configure(conf)
      super

      @enable_auto_download = conf.has_key?('enable_auto_download') ? conf['enable_auto_download'] : DEFAULT_ENABLE_DOWNLOAD

      @md5_url = conf.has_key?('md5_url') ? conf['md5_url'] : DEFAULT_MD5_URL

      @download_url = conf.has_key?('download_url') ? conf['download_url'] : DEFAULT_DOWNLOAD_URL

      @md5_path = conf.has_key?('md5_path') ? conf['md5_path'] : DEFAULT_MD5_PATH

      @database_path = conf.has_key?('database_path') ? conf['database_path'] : DEFAULT_DATABASE_PATH

      @lookup_field = conf.has_key?('lookup_field') ? conf['lookup_field'] : DEFAULT_LOOKUP_FIELD

      @output_field = conf.has_key?('output_field') ? conf['output_field'] : DEFAULT_OUTPU_FIELD

      @field_delimiter = conf.has_key?('field_delimiter') ? conf['field_delimiter'] : DEFAULT_FIELD_DELIMITER

      @flatten = conf.has_key?('flatten') ? to_boolean(conf['flatten']) : DEFAULT_FLATTEN

      @locale = conf.has_key?('locale') ? conf['locale'] : DEFAULT_LOCALE

      @continent = conf.has_key?('continent') ? to_boolean(conf['continent']) : DEFAULT_CONTINENT

      @country = conf.has_key?('country') ? to_boolean(conf['country']) : DEFAULT_COUNTRY

      @city = conf.has_key?('city') ? to_boolean(conf['city']) : DEFAULT_CITY

      @location = conf.has_key?('location') ? to_boolean(conf['location']) : DEFAULT_LOCATION

      @postal = conf.has_key?('postal') ? to_boolean(conf['postal']) : DEFAULT_POSTAL

      @registered_country = conf.has_key?('registered_country') ? to_boolean(conf['registered_country']) : DEFAULT_REGISTERED_COUNTRY

      @represented_country = conf.has_key?('represented_country') ? to_boolean(conf['represented_country']) : DEFAULT_REPRESENTED_COUNTRY

      @subdivisions = conf.has_key?('subdivisions') ? to_boolean(conf['subdivisions']) : DEFAULT_SUBDIVISIONS

      @traits = conf.has_key?('traits') ? to_boolean(conf['traits']) : DEFAULT_TRAITS

      @connection_type = conf.has_key?('connection_type') ? to_boolean(conf['connection_type']) : DEFAULT_CONNECTION_TYPE

      if enable_auto_download then
        download_database @download_url, @md5_url, @database_path, @md5_path
      end

      @database = MaxMindDB.new(@database_path)
    end

    def filter(tag, time, record)
      ip = record[@lookup_field]

      unless ip.nil? then
        geoip = @database.lookup(ip)

        if geoip.found? then
          #geoip_hash = geoip.to_hash

          if @continent then
            continent_hash = {}

            continent_hash['code'] = geoip.continent.code
            continent_hash['geoname_id'] = geoip.continent.geoname_id
            continent_hash['iso_code'] = geoip.continent.iso_code
            continent_hash['name'] = geoip.continent.name(@locale)

            if @flatten then
              record.merge!(to_flatten(continent_hash, [@output_field, 'continent'], @field_delimiter))
            else
              record[[@output_field, 'continent'].join(@field_delimiter)] = continent_hash.to_json
            end
          end

          if @country then
            country_hash = {}

            country_hash['code'] = geoip.country.code
            country_hash['geoname_id'] = geoip.country.geoname_id
            country_hash['iso_code'] = geoip.country.iso_code
            country_hash['name'] = geoip.country.name(@locale)

            if @flatten then
              record.merge!(to_flatten(country_hash, [@output_field, 'country'], @field_delimiter))
            else
              record[[@output_field, 'country'].join(@field_delimiter)] = country_hash.to_json
            end
          end

          if @city then
            city_hash = {}

            city_hash['code'] = geoip.city.code
            city_hash['geoname_id'] = geoip.city.geoname_id
            city_hash['iso_code'] = geoip.city.iso_code
            city_hash['name'] = geoip.city.name(@locale)

            if @flatten then
              record.merge!(to_flatten(city_hash, [@output_field, 'city'], @field_delimiter))
            else
              record[[@output_field, 'city'].join(@field_delimiter)] = city_hash.to_json
            end
          end

          if @location then
            location_hash = {}

            location_hash['latitude'] = geoip.location.latitude
            location_hash['longitude'] = geoip.location.longitude
            location_hash['metro_code'] = geoip.location.metro_code
            location_hash['time_zone'] = geoip.location.time_zone

            if @flatten then
              record.merge!(to_flatten(location_hash, [@output_field, 'location'], @field_delimiter))
            else
              record[[@output_field, 'location'].join(@field_delimiter)] = location_hash.to_json
            end
          end

          if @postal then
            postal_hash = {}

            postal_hash['code'] = geoip.postal.code

            if @flatten then
              record.merge!(to_flatten(postal_hash, [@output_field, 'postal'], @field_delimiter))
            else
              record[[@output_field, 'postal'].join(@field_delimiter)] = postal_hash.to_json
            end
          end

          if @registered_country then
            registered_country_hash = {}

            registered_country_hash['code'] = geoip.registered_country.code
            registered_country_hash['geoname_id'] = geoip.registered_country.geoname_id
            registered_country_hash['iso_code'] = geoip.registered_country.iso_code
            registered_country_hash['name'] = geoip.registered_country.name(@locale)

            if @flatten then
              record.merge!(to_flatten(registered_country_hash, [@output_field, 'registered_country'], @field_delimiter))
            else
              record[[@output_field, 'registered_country'].join(@field_delimiter)] = registered_country_hash.to_json
            end
          end

          if @represented_country then
            represented_country_hash = {}

            represented_country_hash['code'] = geoip.represented_country.code
            represented_country_hash['geoname_id'] = geoip.represented_country.geoname_id
            represented_country_hash['iso_code'] = geoip.represented_country.iso_code
            represented_country_hash['name'] = geoip.represented_country.name(@locale)

            if @flatten then
              record.merge!(to_flatten(represented_country_hash, [@output_field, 'represented_country'], @field_delimiter))
            else
              record[[@output_field, 'represented_country'].join(@field_delimiter)] = represented_country_hash.to_json
            end
          end

          if @subdivisions then
            subdivision_arry = []

            i = 0
            geoip.subdivisions.each do |subdivision|
              subdivision_hash = {}

              subdivision_hash['code'] = subdivision.code
              subdivision_hash['geoname_id'] = subdivision.geoname_id
              subdivision_hash['iso_code'] = subdivision.iso_code
              subdivision_hash['name'] = subdivision.name(@locale)

              subdivision_arry.push(subdivision_hash)

              i = i + 1
            end

            if @flatten then
              i = 0
              subdivision_arry.each do |subdivision|
                record.merge!(to_flatten(subdivision, [@output_field, 'subdivisions', i.to_s], @field_delimiter))
                i = i + 1
              end
            else
              record[[@output_field, 'subdivisions'].join(@field_delimiter)] = subdivision_arry.to_json
            end
          end

          if @traits then
            traits_hash = {}

            traits_hash['is_anonymous_proxy'] = geoip.traits.is_anonymous_proxy
            traits_hash['is_satellite_provider'] = geoip.traits.is_satellite_provider

            if @flatten then
              record.merge!(to_flatten(traits_hash, [@output_field, 'traits'], @field_delimiter))
            else
              record[[@output_field, 'traits'].join(@field_delimiter)] = traits_hash.to_json
            end
          end

          if @connection_type then
            record[[@output_field, 'connection_type'].join(@field_delimiter)] = geoip.connection_type
          end

          log.info "Record: %s" % record.inspect
        else
          log.warn "It was not possible to look up the #{ip}."
        end
      end

      return record
    end

    def to_flatten(hash, stack=[], delimiter='/')
      output = {}

      hash.keys.each do |key|
        stack.push key

        if hash[key].instance_of?(Hash) then
          output.merge!(to_flatten(hash[key], stack, delimiter))
        else
          output[stack.join(delimiter)] = hash[key]
        end

        stack.pop
      end

      return output
    end

    def to_boolean(string)
      if string== true || string =~ (/(true|t|yes|y|1)$/i) then
        return true
      elsif string== false || string.nil? || string =~ (/(false|f|no|n|0)$/i)
        return false
      else
        return false
      end
    end

    def download_database(download_url, md5_url, database_path, md5_path)
      # database directory
      database_dir = File.dirname database_path
      md5_dir = File.dirname md5_path

      # create database directory if directory does not exist.
      FileUtils.mkdir_p(database_dir) unless File.exist?(database_dir)
      FileUtils.mkdir_p(md5_dir) unless File.exist?(md5_dir)

      # create empty md5 file if file does not exist.
      File.open(md5_path, 'wb').close() unless File.exist?(md5_path)

      # read saved md5
      current_md5 = nil
      begin
        open(md5_path, 'rb') do |data|
          current_md5 = data.read
        end
        log.info "Current MD5: %s" % current_md5
      rescue => e
        log.warn e.message
      end

      # fetch md5
      fetched_md5 = nil
      begin
        open(md5_url, 'rb') do |data|
          fetched_md5 = data.read
        end
        log.info "Fetched MD5: %s" % fetched_md5
      rescue => e
        log.warn e.message
      end

      # check md5
      unless current_md5 == fetched_md5 then
        # download new database
        download_path = database_dir + '/' + File.basename(download_url)
        begin
          log.info "Download: %s" % download_url
          open(download_path, 'wb') do |output|
            open(download_url, 'rb') do |data|
              output.write(data.read)
            end
          end
          log.info "Download done: %s" % download_path
        rescue => e
          log.warn e.message
        end

        # unzip new database temporaly
        tmp_database_path = database_dir + '/tmp_' + File.basename(database_path)
        begin
          log.info "Unzip: %s" % download_path
          open(tmp_database_path, 'wb') do |output|
            Zlib::GzipReader.open(download_path) do |gz|
              output.write(gz.read)
            end
          end
          log.info "Unzip done: %s" % tmp_database_path
        rescue => e
          puts e.message
        end

        # check mkd5
        temp_md5 = Digest::MD5.hexdigest(File.open(tmp_database_path, 'rb').read)
        log.info "New MD5: %s" % temp_md5
        if fetched_md5 == temp_md5 then
          log.info "Rename: %s to %s" % [tmp_database_path, database_path]
          FileUtils.mv(tmp_database_path, database_path)
          log.info "Rename done: %s to %s" % [tmp_database_path, database_path]

          # record new md5
          log.info "Save: %s" % md5_path
          File.write(md5_path, fetched_md5)
          log.info "Save done: %s" % md5_path
        else
          log.info "MD5 missmatch: Fetched MD5 (%s) != New MD5 (%s) ; " % [fetched_md5, temp_md5]
        end
      end
    end
  end
end
