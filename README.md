<h1 align="center">sponsors.cr</h1>
<h4 align="center">CLI tool to transform filesystem-managed DNS entries into consumable formats</h4>
<p align="center">
  <br />
    <a href="https://github.com/GeopJr/sponsors.cr/blob/main/CODE_OF_CONDUCT.md"><img src="https://img.shields.io/badge/Contributor%20Covenant-v2.1-ffffff.svg?style=for-the-badge&labelColor=000000" alt="Code Of Conduct" /></a>
    <a href="https://github.com/GeopJr/sponsors.cr/blob/main/LICENSE"><img src="https://img.shields.io/badge/LICENSE-BSD--2--Clause-ffffff.svg?style=for-the-badge&labelColor=000000" alt="BSD-2-Clause" /></a>
    <a href="https://github.com/GeopJr/sponsors.cr/actions"><img src="https://img.shields.io/github/workflow/status/geopjr/sponsors.cr/Specs%20&%20Lint/main?labelColor=000000&style=for-the-badge" alt="ci action status" /></a>
</p>

## What is sponsors.cr?

Sponsors.cr is a CLI & shard that takes a filesystem-managed DNS entry list and converts it into various formats to be parsed by other tools.

This was made for me to gather DNS entries from my [sponsors](https://github.com/sponsors/GeopJr) and push them to my host.

Example structure:

```tree
domains/
├── milking.men
│   └── bar.json
└── queer.software
    ├── foo.json
    └── geopjr.json
```

The folder is named after the domain while each json can be named whatever you please, in my case it's the user's username.

Then in the json format is:

```json
{
  "contact": {
    "email": "String?",
    "twitter": "String?",
    "fediverse": "String?",
    "discord": "String?",
    "matrix": "String?",
    "session": "String?",
    "wire": "String?",
    "telegram": "String?"
  },
  "records": {
    "<A/AAAA/CNAME/TXT>": [
      {
        "name": "String",
        "target": "String",
        "ttl": "Int32?",
        "description": "String?"
      }
    ]
  }
}
```

For example:

```json
{
  "contact": {
    "twitter": "GeopJr1312"
  },
  "records": {
    "CNAME": [
      {
        "name": "geopjr",
        "target": "geopjr.dev",
        "description": "Personal website"
      }
    ],
    "A": [
      {
        "name": "queer.software",
        "target": "192.0.2.1",
        "description": "Rewrite rule"
      },
      {
        "name": "wwww",
        "target": "192.0.2.1",
        "description": "Rewrite rule"
      }
    ]
  }
}
```

("contact" is being used as a way to communicate with users on DNS related issues).

## Installation

Get the latest static-linked binary from the [releases](https://github.com/GeopJr/sponsors.cr/releases/latest) page.

## Usage

### DNS Structure

### CLI

```crystal
sponsors v1.0.0

USAGE:
    sponsors -i <DIRECTORY> -t <TYPE> [FLAGS]

FLAGS:
    -i DIRECTORY, --input=DIRECTORY  Input directory to look for json files in - Default: .
    -t TYPE, --type=TYPE             The output type (JSON, HJSON, PLAIN, TABLE) - Default: TABLE
    -o DIRECTORY, --output=DIRECTORY Write to files in DIRECTORY - Default: STDOUT
    -r, --overwrite                  Overwrite if files already exist - Default: false
    -h, --help                       Show this help
```

- Plain: A plain format where each value is separated with a `~` - allows easy manual parsing

```
TYPE ~ NAME ~ TARGET ~ TTL ~ COMMENTS
```

```
CNAME ~ geopjr ~ geopjr.dev ~ 14400 ~ Personal website
A ~ queer.software ~ 192.0.2.1 ~ 14400 ~ Rewrite rule
A ~ wwww ~ 192.0.2.1 ~ 14400 ~ Rewrite rule
```

- Table: Markdown tables

```
| TYPE  |      NAME      |   TARGET   |  TTL  |     COMMENTS     |
| :---: | :------------: | :--------: | :---: | :--------------: |
| CNAME |     geopjr     | geopjr.dev | 14400 | Personal website |
|   A   | queer.software | 192.0.2.1  | 14400 |   Rewrite rule   |
|   A   |      wwww      | 192.0.2.1  | 14400 |   Rewrite rule   |
```

- JSON: Well, json

```json
{
  "records": [
    {
      "type": "String",
      "name": "String",
      "<content/ipv4/ipv6>": "String",
      "ttl": "Int32"
    }
  ]
}
```

```json
{
  "records": [
    {
      "type": "CNAME",
      "name": "geopjr",
      "content": "geopjr.dev",
      "ttl": 14400
    },
    {
      "type": "A",
      "name": "queer.software",
      "ipv4": "192.0.2.1",
      "ttl": 14400
    },
    {
      "type": "A",
      "name": "wwww",
      "ipv4": "192.0.2.1",
      "ttl": 14400
    }
  ]
}
```

- HJSON: HJSON is a mix of json and yaml - here is being used like json but with comments

```json
{
  "records": [
    {
      "type": "CNAME",
      # Comment: Personal website
      "name": "geopjr",
      "content": "geopjr.dev",
      "ttl": 14400
    },
    {
      "type": "A",
      # Comment: Rewrite rule
      "name": "queer.software",
      "ipv4": "192.0.2.1",
      "ttl": 14400
    },
    {
      "type": "A",
      # Comment: Rewrite rule
      "name": "wwww",
      "ipv4": "192.0.2.1",
      "ttl": 14400
    }
  ]
}
```

### Shard

You can customize it or use parts of it, take a look at the [docs](https://geopjr.github.io/sponsors.cr/) & [./src/sponsors.cr](./src/sponsors.cr).

## Contributing

1. Read the [Code of Conduct](https://github.com/GeopJr/sponsors.cr/blob/main/CODE_OF_CONDUCT.md)
2. Fork it (<https://github.com/GeopJr/sponsors.cr/fork>)
3. Create your feature branch (`git checkout -b my-new-feature`)
4. Commit your changes (`git commit -am 'Add some feature'`)
5. Push to the branch (`git push origin my-new-feature`)
6. Create a new Pull Request

## Sponsors

<p align="center">

[![GeopJr Sponsors](https://cdn.jsdelivr.net/gh/GeopJr/GeopJr@main/sponsors.svg)](https://github.com/sponsors/GeopJr)

</p>
