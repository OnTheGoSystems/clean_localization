require 'bundler/setup'
require 'clean_localization/client'
require 'pry'
require 'yaml'
require 'active_support/all'
require 'rspec/its'

path = File.expand_path(File.dirname(__FILE__))

RSpec.configure do |c|
  c.before do
    CleanLocalization::Config.base_path = Pathname("#{path}/resources")
    CleanLocalization::Client.data = nil
  end
end
