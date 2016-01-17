# Fluent::Plugin::GeoIPFilter

This is a [Fluentd](http://fluentd.org/) filter plugin for adding [GeoIP data](http://dev.maxmind.com/geoip/geoip2/geolite2/) to record. Supports the new Maxmind v2 database formats.

## Installation

Add this line to your application's Gemfile:

```
gem 'fluent-plugin-output-solr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-output-solr

## Config parameters

### database_pash

```
database_path /path/to/GeoLite2-City.mmdb
```

### lookup_field

```
lookup_field host
```

### output_field

```
output_field geoip
```

### flatten

```
flatten true
```

## Plugin setup examples

```
<filter tail.log>
  @type geoip

  database_path /path/to/GeoLite2-City.mmdb
  lookup_field host
  output_field geoip
  flatten true
</filter>
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mosuka/fluent-plugin-filter-geoip.

