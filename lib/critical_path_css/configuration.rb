require 'erb'
module CriticalPathCss
  class Configuration
    def initialize(config)
      @config = config
    end

    def base_url
      @config['base_url']
    end

    def default_manifest
      @config['default_manifest']
    end

    def exceptions
      @config['exceptions']
    end

    def penthouse_options
      @config['penthouse_options'] || {}
    end

    def path_for_route(route)
      exceptions[route] || default_manifest
    end
  end
end
