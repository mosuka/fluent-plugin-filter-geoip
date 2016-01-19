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
</filter>
```

Assuming following inputs are coming:

```javascript
{
  "host":"212.99.123.25",
  "user":"-",
  "method":"GET",
  "path":"/item/sports/4981",
  "code":"200",
  "size":"94",
  "referer":"/category/electronics",
  "agent":"Mozilla/5.0 (Windows NT 6.0; rv:10.0.1) Gecko/20100101 Firefox/10.0.1"
}
```

then output bocomes as belows:

```javascript
{
  "host":"212.99.123.25",
  "user":"-",
  "method":"GET",
  "path":"/item/sports/4981",
  "code":"200",
  "size":"94",
  "referer":"/category/electronics",
  "agent":"Mozilla/5.0 (Windows NT 6.0; rv:10.0.1) Gecko/20100101 Firefox/10.0.1",
  "geoip_continent_code":"EU",
  "geoip_continent_geoname_id":6255148,
  "geoip_continent_names_de":"Europa",
  "geoip_continent_names_en":"Europe",
  "geoip_continent_names_es":"Europa",
  "geoip_continent_names_fr":"Europe",
  "geoip_continent_names_ja":"ヨーロッパ",
  "geoip_continent_names_pt-BR":"Europa",
  "geoip_continent_names_ru":"Европа",
  "geoip_continent_names_zh-CN":"欧洲",
  "geoip_country_geoname_id":3017382,
  "geoip_country_iso_code":"FR",
  "geoip_country_names_de":"Frankreich",
  "geoip_country_names_en":"France",
  "geoip_country_names_es":"Francia",
  "geoip_country_names_fr":"France",
  "geoip_country_names_ja":"フランス共和国",
  "geoip_country_names_pt-BR":"França",
  "geoip_country_names_ru":"Франция",
  "geoip_country_names_zh-CN":"法国",
  "geoip_city_geoname_id":3038354,
  "geoip_city_names_de":"Aix-en-Provence",
  "geoip_city_names_en":"Aix-en-Provence",
  "geoip_city_names_es":"Aix-en-Provence",
  "geoip_city_names_fr":"Aix-en-Provence",
  "geoip_city_names_ja":"エクス＝アン＝プロヴァンス",
  "geoip_city_names_pt-BR":"Aix-en-Provence",
  "geoip_city_names_ru":"Экс-ан-Прованс",
  "geoip_city_names_zh-CN":"普罗旺斯地区艾克斯",
  "geoip_location_latitude":43.5283,
  "geoip_location_longitude":5.4497,
  "geoip_location_time_zone":"Europe/Paris",
  "geoip_postal_code":"13090",
  "geoip_registered_country_geoname_id":3017382,
  "geoip_registered_country_iso_code":"FR",
  "geoip_registered_country_names_de":"Frankreich",
  "geoip_registered_country_names_en":"France",
  "geoip_registered_country_names_es":"Francia",
  "geoip_registered_country_names_fr":"France",
  "geoip_registered_country_names_ja":"フランス共和国",
  "geoip_registered_country_names_pt-BR":"França",
  "geoip_registered_country_names_ru":"Франция",
  "geoip_registered_country_names_zh-CN":"法国",
  "geoip_subdivisions_0_geoname_id":2985244,
  "geoip_subdivisions_0_iso_code":"U",
  "geoip_subdivisions_0_names_de":"Provence-Alpes-Côte d’Azur",
  "geoip_subdivisions_0_names_en":"Provence-Alpes-Côte d'Azur",
  "geoip_subdivisions_0_names_es":"Provenza-Alpes-Costa Azul",
  "geoip_subdivisions_0_names_fr":"Provence-Alpes-Côte d'Azur",
  "geoip_subdivisions_0_names_ja":"プロヴァンス＝アルプ＝コート・ダジュール地域圏",
  "geoip_subdivisions_0_names_pt-BR":"Provença-Alpes-Costa Azul",
  "geoip_subdivisions_0_names_ru":"Прованс — Альпы — Лазурный Берег",
  "geoip_subdivisions_0_names_zh-CN":"普罗旺斯-阿尔卑斯-蓝色海岸",
  "geoip_subdivisions_1_geoname_id":3031359,
  "geoip_subdivisions_1_iso_code":"13",
  "geoip_subdivisions_1_names_de":"Bouches-du-Rhône",
  "geoip_subdivisions_1_names_en":"Bouches-du-Rhône",
  "geoip_subdivisions_1_names_es":"Bocas del Ródano",
  "geoip_subdivisions_1_names_fr":"Bouches-du-Rhône",
  "geoip_subdivisions_1_names_pt-BR":"Bocas do Ródano",
  "geoip_localtion_latlon":"43.5283,5.4497"
}
```

## Development

After checking out the repo, run `bundle install` to install dependencies. Then, run `rake test` to run the tests.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mosuka/fluent-plugin-filter-geoip.

