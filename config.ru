require 'monet_web'

MonetWeb::App.set :config, "config.yaml"
run MonetWeb::App.new