require "bundler/gem_tasks"
require 'sinatra/asset_pipeline/task'
require 'monet/tasks'
require 'monet_web'

Sinatra::AssetPipeline::Task.define! MonetWeb::App

task :run do
  MonetWeb::App.run!
end
