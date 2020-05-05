require 'critical_path_css/configuration'
require 'critical_path_css/css_fetcher'
require 'critical_path_css/rails/config_loader'

module CriticalPathCss
  CACHE_NAMESPACE = 'critical-path-css'.freeze
  EXPIRATION = 1.day

  def self.generate(route)
    ::Rails.cache.write(cache_key(route), fetcher.fetch_route(route), namespace: CACHE_NAMESPACE, expires_in: EXPIRATION)
  end

  def self.clear(route)
    ::Rails.cache.delete(cache_key(route), namespace: CACHE_NAMESPACE)
  end

  def self.clear_matched(routes)
    ::Rails.cache.delete_matched(routes, namespace: CACHE_NAMESPACE)
  end

  def self.fetch(route)
    ::Rails.cache.read(cache_key(route), namespace: CACHE_NAMESPACE) || ''
  end

  def self.fetcher
    @fetcher ||= CssFetcher.new(Configuration.new(config_loader.config))
  end

  def self.config_loader
    @config_loader ||= CriticalPathCss::Rails::ConfigLoader.new
  end

  def self.cache_key(route)
    stylesheet_filename = fetcher.config.path_for_route(route).split('/').last
    "#{stylesheet_filename}-#{route}"
  end
end
