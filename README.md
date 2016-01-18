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

### field_prefix

```
field_prefix geoip
```

### field_delimiter

```
field_delimiter _
```

### flatten

```
flatten true
```

### continent

```
continent true
```

### country

```
country true
```

### city

```
city true
```

### location

```
location true
```

### postal

```
postal true
```

### registered_country

```
registered_country true
```

### represented_country

```
represented_country true
```

### subdivisions

```
subdivisions true
```

### traits

```
traits true
```

### connection_type

```
connection_type true
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

