# Fluent::Plugin::GeoIPFilter

This is a [Fluentd](http://fluentd.org/) filter plugin for adding [GeoIP data](http://dev.maxmind.com/geoip/geoip2/geolite2/) to record. Supports the new Maxmind v2 database formats.

## Installation

Add this line to your application's Gemfile:

```
gem 'fluent-plugin-filter-geoip'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-filter-geoip

## Config parameters

### enable_auto_download

If true, enable to download GeoIP2 database autometically (default: true).

```
enable_auto_download true
```

### md5_url

GeoIP2 MD5 checksum URL (default: http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.md5)

```
md5_url http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.md5
```

### download_url

GeoIP2 database download URL (default: http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz).

```
download_url http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
```

### md5_path

GeoIP2 MD5 checksum path. (default: ./geoip/database/GeoLite2-City.md5)

```
md5_path ./geoip/database/GeoLite2-City.md5
```

### database_path

GeoIP2 database path. (default: ./geoip/database/GeoLite2-City.md5)

```
database_path ./geoip/database/GeoLite2-City.mmdb
```

### lookup_field

Specify the field name that IP address is stored (default: ip).

```
lookup_field host
```

### output_field

Specify the field name that store the result (default: geoip).

```
output_field geoip
```

### field_delimiter

Specify the field delimiter (default .).

```
field_delimiter .
```

### flatten

If true, to flatten the result using field_delimiter (default: false).

```
flatten false
```

### locale

Get the data for the specified locale (default: en).

```
locale en
```

### continent

If true, to get continent information (default: true).

```
continent true
```

### country

If true, to get country information (default: true).

```
country true
```

### city

If true, to get city information (default: true).

```
city true
```

### location

If true, to get location information (default: true).

```
location true
```

### postal

If true, to get postal information (default: true).

```
postal true
```

### registered_country

If true, to get registered country information (default: true).

```
registered_country true
```

### represented_country

If true, to get represented country information (default: true).

```
represented_country true
```

### subdivisions

If true, to get subdivisions information (default: true).

```
subdivisions true
```

### traits

If true, to get traits information (default: true).

```
traits true
```

### connection_type

If true, to get connection type information (default: true).

```
connection_type true
```

## Plugin setup examples

```
<filter tail.log>
  @type geoip

  enable_auto_download true
  md5_url http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.md5
  download_url http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
  md5_path ./geoip/database/GeoLite2-City.md5
  database_path ./geoip/database/GeoLite2-City.mmdb

  lookup_field clientip
  field_prefix geoip
  field_delimiter .
  flatten false

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
</filter>
```

Assuming following inputs are coming:

```javascript
{
  "clientip": "200.114.49.218"
}
```

then output bocomes as belows:

```javascript
{
  "clientip": "200.114.49.218",
  "geoip": {
    "continent": {
      "code": "SA",
      "geoname_id": 6255150,
      "name": "South America"
    },
    "country": {
      "geoname_id": 3686110,
      "iso_code": "CO",
      "name": "Colombia"
    },
    "city": {
      "geoname_id": 3674962,
      "name": "Medellín"
    },
    "location": {
      "latitude": 6.2518,
      "longitude": -75.5636,
      "time_zone": "America/Bogota"
    },
    "registered_country": {
      "geoname_id": 3686110,
      "iso_code": "CO",
      "name": "Colombia"
    },
    "subdivisions": [{
      "geoname_id": 3689815,
      "iso_code": "ANT",
      "name": "Antioquia"
    }]
  }
}
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mosuka/fluent-plugin-filter-geoip.

