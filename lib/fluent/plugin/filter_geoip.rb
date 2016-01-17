require 'maxminddb'

module Fluent
  class GeoIPFilter < Filter
    Fluent::Plugin.register_filter('geoip', self)

    DEFAULT_LOOKUP_FIELD = 'ip'
    DEFAULT_OUTPUT_FIELD = 'geoip'
    DEFAULT_FLATTEN = false

    config_param :database_path, :string, :default => nil,
                 :desc => ''

    config_param :lookup_field, :string, :default => DEFAULT_LOOKUP_FIELD,
                 :desc => ''

    config_param :output_field, :string, :default => DEFAULT_OUTPUT_FIELD,
                 :desc => ''

    config_param :flatten, :bool, :default => DEFAULT_FLATTEN,
                 :desc => ''

    def initialize
      super
    end

    def configure(conf)
      super

      @database_path = conf['database_path']

      @lookup_field = conf.has_key?('lookup_field') ? conf['lookup_field'] : DEFAULT_LOOKUP_FIELD

      @output_field = conf.has_key?('output_field') ? conf['output_field'] : DEFAULT_OUTPUT_FIELD

      @flatten = conf.has_key?('flatten') ? conf['flatten'] : DEFAULT_FLATTEN

      @database = MaxMindDB.new(@database_path)
    end

    def filter(tag, time, record)
      ip = record[@lookup_field]

      unless ip.nil? then
        geoip = @database.lookup(ip)

        if geoip.found? then
          log.info geoip
          record[@output_field] = geoip.to_hash
        end

      end

    end
  end
end
