# pb-cli

A command line interface for Pushbullet.

https://www.pushbullet.com/

## Installation

Run:

```
$ gem install pb-cli
```

And then execute:

```
$ pb init <ACCESS-TOKEN>
```

To access the Pushbullet API you'll need an access token so the server knows who you are. You can get one from your [Account Settings](https://www.pushbullet.com/#settings/account) page.

## How to use

Send notification.

```
$ pb push <MESSAGE> [--title <TITLE>]
```

See also `pb help`.

## Development

```
$ git clone git@github.com:miya0001/pb-cli.git
$ cd pb-cli
$ bundle install --path vendor/bundle
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/miya0001/pb-cli.
