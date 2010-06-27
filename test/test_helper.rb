$:.unshift(File.dirname(__FILE__) + '/../lib')

require 'rubygems'
require 'test/unit'
require 'active_record'
require 'active_support'
require 'buffer_count'

config = YAML::load(IO.read(File.dirname(__FILE__) + '/database.yml'))
ActiveRecord::Base.establish_connection(config[ENV['DB'] || 'plugin_test'])

load(File.dirname(__FILE__) + "/schema.rb") if File.exist?(File.dirname(__FILE__) + "/schema.rb")

silence_warnings { Object.const_set "RAILS_CACHE", ActiveSupport::Cache.lookup_store(:memory_store)}

module Rails
  def self.cache
    RAILS_CACHE
  end
end
