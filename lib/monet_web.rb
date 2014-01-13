require 'pathname'
require 'cgi'

require "monet_web/version"
require "sinatra/base"
require "sinatra/content_for"
require 'sinatra/asset_pipeline'

require 'coffee_script'
require 'less'

require 'monet'

module MonetWeb
  class App < Sinatra::Base
    set :root, File.join(File.dirname(__FILE__), "monet_web")
    set :config, Monet::Config.load
    set :public_folder, File.join(File.dirname(__FILE__), "..", "public")

    set :assets_prefix, %w(lib/monet_web/assets vendor/assets bower_components/**)
    set :baseline_control, Monet::BaselineControl.new(config)

    register Sinatra::AssetPipeline
    helpers Sinatra::ContentFor

    SIZE_MATCHER = /-(?<size>\d+)$/

    def sites
      Dir.glob File.join(settings.config.baseline_dir, "*")
    end

    def images_for_site(site)
      paths = Dir.glob(File.join(settings.config.baseline_dir, site, "*.png")).reject {|img| img.include? "-diff.png" }
      paths.map {|path| Monet::Image.new path }
    end

    def path_to_url(path)
      "/site/#{path_to_name(path)}"
    end

    def path_to_name(path)
      File.basename path
    end

    def image_title(path)
      File.basename(path, ".png").gsub(SIZE_MATCHER, "").gsub("|", "/")
    end

    def encode_path(path)
      CGI::escape path
    end

    def decode_path(path)
      CGI::unescape path
    end

    def simple_name(name)
      name.split("|").last.split("-").first
    end

    def compare_path(site, name)
      "/#{site}/compare/#{name.gsub(".png", "")}"
    end

    def router
      @router ||= Monet::Router.new settings.config
    end

    get "/" do
      erb :sites, names: sites
    end

    get "/site/:name" do |name|
      erb :images, locals: { images: images_for_site(name), site: name }
    end

    get "/:site/compare/:name" do |site, name|
      image_path = router.baseline_dir("#{name}.png")
      erb :compare, locals: { image: Monet::Image.new(image_path), site: site }
    end

    get "/reject" do
      path = decode_path params[:path]
      settings.baseline_control.discard path

    end
  end
end
