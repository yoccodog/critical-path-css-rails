module CriticalPathCss
  module Rails
    class ConfigLoader
      CONFIGURATION_FILENAME = 'critical_path_css.yml'.freeze

      def initialize
        validate_css_paths
        format_css_paths
      end

      def config
        @config ||= YAML.safe_load(ERB.new(File.read(configuration_file_path)).result, [], [], true)[::Rails.env]
      end

      private

      def configuration_file_path
        @configuration_file_path ||= ::Rails.root.join('config', CONFIGURATION_FILENAME)
      end

      def format_css_paths
        config['default_manifest'] = format_path(precompiled_name(config['default_manifest']))

        if config['exceptions']
          config['exceptions'].each_pair do |path, stylesheet|
            config['exceptions'][path] = format_path(precompiled_name(stylesheet))
          end
        end
      end

      def format_path(path)
        "#{::Rails.root}/public#{path}"
      end

      def validate_css_paths
        if config['default_manifest'].empty?
          raise LoadError, 'default_manifest must be specified'
        end
      end

      def precompiled_name(stylesheet)
        ActionController::Base.helpers.stylesheet_path(stylesheet, host: '')
      end
    end
  end
end
