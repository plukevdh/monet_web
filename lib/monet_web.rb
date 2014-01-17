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
    set :public_folder, File.join(File.dirname(__FILE__), "..", "public")
    set :assets_prefix, %w(lib/monet_web/assets vendor/assets bower_components/**)
    set :assets_precompile, %w(
      application.css application.js
      compare.css compare.js
      images.js images.css
      *.png *.jpg *.svg *.eot *.ttf *.woff
    )

    register Sinatra::AssetPipeline
    helpers Sinatra::ContentFor

    SIZE_MATCHER = /-(?<size>\d+)$/

    def config
      raise "Please set MonetWeb::App config via `MonetWeb::App.set :config, [String|Monet::Config]`" unless defined?(settings.config)
      @config ||= (settings.config.is_a? String) ? Monet::Config.load(settings.config) : settings.config
    end

    def sites
      Dir.glob File.join(config.baseline_dir, "*")
    end

    def images_for_site(site)
      paths = Dir.glob(File.join(config.baseline_dir, site, "*.png")).reject {|img| img.include? "-diff.png" }
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

    def truncate(string, max=35)
      return string unless (string.length > max)
      string[0..max-3] + "..."
    end

    def simple_name(name)
      truncate name.split("|").last.gsub(/-(\d+)\.png/, "")
    end

    def compare_path(site, name)
      "/#{site}/compare/#{url_name name}"
    end

    def reject_path(site, name)
      "/#{site}/reject/#{url_name name}"
    end

    def accept_path(site, name)
      "/#{site}/accept/#{url_name name}"
    end

    def url_name(path)
      path.gsub(".png", "")
    end

    def reimagerize(name)
      image_path = router.baseline_dir("#{name}.png")
      Monet::Image.new(image_path)
    end

    def router
      @router ||= Monet::Router.new config
    end

    def baseline_control
      @basenline_control ||= Monet::BaselineControl.new config
    end

    def page_log
      @log ||= Monet::PageLogger.load "./spider.txt"
    end

    def errored?(url)
      page_log.failed?(url)
    end

    def error_code(url)
      page_log.status_for(url)
    end

    get "/" do
      erb :sites, names: sites
    end

    get "/site/:name" do |name|
      erb :images, locals: { images: images_for_site(name), site: name }
    end

    get "/:site/compare/:name" do |site, name|
      image_path = router.baseline_dir("#{name}.png")
      erb :compare, locals: { image: reimagerize(name), site: site }
    end

    get "/:site/reject/:name" do |site, name|
      img = reimagerize(name)
      baseline_control.discard router.capture_dir(img.name)
      baseline_control.discard router.diff_dir(img.name)

      redirect "/site/#{site}"
    end

    get "/:site/accept/:name" do |site, name|
      img = reimagerize(name)
      baseline_control.baseline router.capture_dir(img.name)

      redirect "/site/#{site}"
    end

    get "/site/:site/debug" do |site|
      erb :debug, locals: { images: images_for_site(site), site: site }
    end
  end
end
