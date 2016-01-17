require 'helper'

class SolrOutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end

  CONFIG = %[
    database_path ./data/GeoLite2-City.mmdb
    lookup_field  ip
    output_field  geoip
    flatten       false
  ]

  def create_driver(conf=CONFIG, tag='test')
    Fluent::Test::FilterTestDriver.new(Fluent::GeoIPFilter, tag).configure(conf)
  end

  def test_configure
    d = create_driver CONFIG
    assert_equal 'ip', d.instance.config['lookup_field']
    assert_equal 'geoip', d.instance.config['output_field']
    assert_equal 'false', d.instance.config['flatten']
  end
end