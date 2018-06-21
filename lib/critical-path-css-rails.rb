require 'critical_path_css/configuration'
require 'critical_path_css/css_fetcher'
require 'critical_path_css/rails/config_loader'

module CriticalPathCss
  CACHE_NAMESPACE = 'critical-path-css'.freeze

  def self.generate(route, key = route)
    ::Rails.cache.write(
      key.present? ? key : route,
      CssFetcher.new(config).fetch_route(route),
      namespace: CACHE_NAMESPACE,
      expires_in: 1.week
    )
  end

  def self.generate_all
    CssFetcher.new(config).fetch.each do |route, css|
      ::Rails.cache.write(route, css, namespace: CACHE_NAMESPACE, expires_in: nil)
    end
  end

  def self.clear(route)
    ::Rails.cache.delete(route, namespace: CACHE_NAMESPACE)
  end

  def self.clear_matched(routes)
    ::Rails.cache.delete_matched(routes, namespace: CACHE_NAMESPACE)
  end

  def self.fetch(key)
    ::Rails.cache.read(key, namespace: CACHE_NAMESPACE) || ''
  end

  def self.config
    @config ||= Configuration.new(CriticalPathCss::Rails::ConfigLoader.new.load)
  end
end
