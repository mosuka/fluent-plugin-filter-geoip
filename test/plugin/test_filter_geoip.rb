require 'helper'

class SolrOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup

    # http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
    #system('pwd')
  end

  CONFIG = %[
    download_url http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
    md5_url http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.md5
    database_path ./geoip/database/GeoLite2-City.mmdb
    md5_path ./geoip/database/GeoLite2-City.md5

    lookup_field host
    field_prefix geoip
    field_delimiter _
    flatten true

    continent true
    country true
    city true
    location true
    postal true
    registered_country true
    represented_country true
    subdivisions true
    traits true
    connection_type true
  ]

  def create_driver(conf=CONFIG, tag='test')
    Fluent::Test::FilterTestDriver.new(Fluent::GeoIPFilter, tag).configure(conf)
  end

  def test_configure
    d = create_driver CONFIG
    assert_equal 'host', d.instance.config['lookup_field']
    assert_equal 'geoip', d.instance.config['field_prefix']
    assert_equal '_', d.instance.config['field_delimiter']
    assert_equal 'true', d.instance.config['flatten']
    assert_equal 'true', d.instance.config['continent']
    assert_equal 'true', d.instance.config['country']
    assert_equal 'true', d.instance.config['city']
    assert_equal 'true', d.instance.config['location']
    assert_equal 'true', d.instance.config['postal']
    assert_equal 'true', d.instance.config['registered_country']
    assert_equal 'true', d.instance.config['represented_country']
    assert_equal 'true', d.instance.config['subdivisions']
    assert_equal 'true', d.instance.config['traits']
    assert_equal 'true', d.instance.config['connection_type']
  end

def test_emit
    d = create_driver(CONFIG)
    host = '212.99.123.25'

    d.run do
      d.emit({'host' => host})
    end

    emits = d.emits
    
    assert_equal 1, emits.length

    assert_equal 'test', emits[0][0]

    h = emits[0][2]

    assert_equal '212.99.123.25', h['host']
    assert_equal 'EU', h['geoip_continent_code']
    assert_equal 'FR', h['geoip_country_iso_code']
    assert_equal 'Aix-en-Provence', h['geoip_city_names_en']
    assert_equal 'Europe/Paris', h['geoip_location_time_zone']
    assert_equal '13090', h['geoip_postal_code']
    assert_equal 'FR', h['geoip_registered_country_iso_code']
    assert_equal 'U', h['geoip_subdivisions_0_iso_code']
    assert_equal '13', h['geoip_subdivisions_1_iso_code']
  end
end