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

### download_url

```
download_url http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.mmdb.gz
```

### md5_url

```
md5_url http://geolite.maxmind.com/download/geoip/database/GeoLite2-City.md5
```

### database_path

```
database_path ./geoip/database/GeoLite2-City.mmdb
```

### md5_path

```
md5_path ./geoip/database/GeoLite2-City.md5
```

### enable_auto_download

```
enable_auto_download true
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

### languages

```
languages ["en"]
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
  "geoip_localtion_latlon":""
}
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mosuka/fluent-plugin-filter-geoip.

