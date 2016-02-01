# Fluent::Plugin::GeoIPFilter

This is a [Fluentd](http://fluentd.org/) filter plugin for adding [GeoIP data](http://dev.maxmind.com/geoip/geoip2/geolite2/) to record. Supports the new Maxmind v2 database formats.

## Installation

Add this line to your application's Gemfile:

```
gem 'fluent-plugin-output-geoip'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fluent-plugin-output-geoip

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

If true, to flatten the result using field_delimiter (default: true).

```
flatten true
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

  lookup_field host
  field_prefix geoip
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
</filter>
```

Assuming following inputs are coming:

```javascript
{
  "host":"180.195.25.228",
  "user":"-",
  "method":"GET",
  "path":"/category/giftcards?from=20",
  "code":"200",
  "size":"63",
  "referer":"-",
  "agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1"
}
```

then output bocomes as belows:

```javascript
{
  "host":"180.195.25.228",
  "user":"-",
  "method":"GET",
  "path":"/category/giftcards?from=20",
  "code":"200",
  "size":"63",
  "referer":"-",
  "agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:9.0.1) Gecko/20100101 Firefox/9.0.1",
  "geoip.continent.code":"AS",
  "geoip.continent.geoname_id":6255147,
  "geoip.continent.iso_code":null,
  "geoip.continent.name":"Asia",
  "geoip.country.code":null,
  "geoip.country.geoname_id":1694008,
  "geoip.country.iso_code":"PH",
  "geoip.country.name":"Philippines",
  "geoip.city.code":null,
  "geoip.city.geoname_id":1728893,
  "geoip.city.iso_code":null,
  "geoip.city.name":"Bagumbayan",
  "geoip.location.latitude":13.45,
  "geoip.location.longitude":123.6667,
  "geoip.location.metro_code":null,
  "geoip.location.time_zone":"Asia/Manila",
  "geoip.postal.code":"4513",
  "geoip.registered_country.code":null,
  "geoip.registered_country.geoname_id":1694008,
  "geoip.registered_country.iso_code":"PH",
  "geoip.registered_country.name":"Philippines",
  "geoip.represented_country.code":null,
  "geoip.represented_country.geoname_id":null,
  "geoip.represented_country.iso_code":null,
  "geoip.represented_country.name":null,
  "geoip.subdivisions.0.code":null,
  "geoip.subdivisions.0.geoname_id":7521310,
  "geoip.subdivisions.0.iso_code":"05",
  "geoip.subdivisions.0.name":"Bicol",
  "geoip.subdivisions.1.code":null,
  "geoip.subdivisions.1.geoname_id":1731616,
  "geoip.subdivisions.1.iso_code":"ALB",
  "geoip.subdivisions.1.name":"Province of Albay",
  "geoip.traits.is_anonymous_proxy":null,
  "geoip.traits.is_satellite_provider":null,
  "geoip.connection_type":null,
}
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mosuka/fluent-plugin-filter-geoip.

