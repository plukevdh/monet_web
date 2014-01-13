# MonetWeb

Monet web is the front-end interface to the [Monet](plukevdh/monet) gem. It allows for visual comparison and flagging of a site.

## Installation

Add this line to your application's Gemfile:

    gem 'monet_web'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install monet_web

Since the webapp is Sinatra, you can use it as a Rack app and mount it within your Rails apps as well.

## Configuration

Just create a config.yaml or a Monet::Config object and reference it via the runner:

```
config = Monet::Config.config do |c|
  c.base_url = "http://lance.com"
  c.capture_dir = "./captures"
  ...
end

MonetWeb::App.set :config, config
```

Or



## Usage

To fire up the app, you can run `rake run`. Alternatively you can just use the web server of your choice (thin, mongrel, puma...) and run it via the config.ru file: `thin config.ru`

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

# License

MIT. See LICENSE.txt