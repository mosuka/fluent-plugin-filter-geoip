require 'helper'

class SolrOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup

  end

  CONFIG = %[
    download_url http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
    md5_url http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.md5
    database_path ./geoip/database/GeoLite2-City.mmdb
    md5_path ./geoip/database/GeoLite2-City.md5
    enable_auto_download true

    lookup_field host
    output_field geoip
    field_delimiter .
    flatten true

    locale en

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

  def create_driver(conf=CONFIG)
    Fluent::Test::Driver::Filter.new(Fluent::Plugin::GeoIPFilter).configure(conf)
  end

  def test_configure
    d = create_driver CONFIG
    assert_equal 'host', d.instance.config['lookup_field']
    assert_equal 'geoip', d.instance.config['output_field']
    assert_equal '.', d.instance.config['field_delimiter']
    assert_equal 'true', d.instance.config['flatten']
    assert_equal 'en', d.instance.config['locale']
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

    d.run(default_tag: 'test') do
      d.feed({'host' => host})
    end

    emits = d.filtered

    assert_equal 1, emits.length

    h = emits[0][1]

    assert_equal 'EU', h['geoip.continent.code']
    assert_equal 6255148, h['geoip.continent.geoname_id']
    assert_equal nil, h['geoip.continent.iso_code']
    assert_equal 'Europe', h['geoip.continent.name']

    assert_equal nil, h['geoip.country.code']
    assert_equal 3017382, h['geoip.country.geoname_id']
    assert_equal 'FR', h['geoip.country.iso_code']
    assert_equal 'France', h['geoip.country.name']

    assert_equal nil, h['geoip.city.code']
    assert_equal nil, h['geoip.city.geoname_id']
    assert_equal nil, h['geoip.city.iso_code']
    assert_equal nil, h['geoip.city.name']

    assert_equal 48.8582, h['geoip.location.latitude']
    assert_equal 2.3387000000000002, h['geoip.location.longitude']
    assert_equal nil, h['geoip.location.metro_code']
    assert_equal 'Europe/Paris', h['geoip.location.time_zone']

    assert_equal nil, h['geoip.postal.code']

    assert_equal nil, h['geoip.registered_country.code']
    assert_equal 3017382, h['geoip.registered_country.geoname_id']
    assert_equal 'FR', h['geoip.registered_country.iso_code']
    assert_equal 'France', h['geoip.registered_country.name']

    assert_equal nil, h['geoip.represented_country.code']
    assert_equal nil, h['geoip.represented_country.geoname_id']
    assert_equal nil, h['geoip.represented_country.iso_code']
    assert_equal nil, h['geoip.represented_country.name']

    assert_equal nil, h['geoip.subdivisions.0.code']
    assert_equal nil, h['geoip.subdivisions.0.geoname_id']
    assert_equal nil, h['geoip.subdivisions.0.iso_code']
    assert_equal nil, h['geoip.subdivisions.0.name']

    assert_equal nil, h['geoip.subdivisions.1.code']
    assert_equal nil, h['geoip.subdivisions.1.geoname_id']
    assert_equal nil, h['geoip.subdivisions.1.iso_code']
    assert_equal nil, h['geoip.subdivisions.1.name']

    assert_equal nil, h['geoip.traits.is_anonymous_proxy']
    assert_equal nil, h['geoip.traits.is_satellite_provider']

    assert_equal nil, h['geoip.connection_type']
  end
end
