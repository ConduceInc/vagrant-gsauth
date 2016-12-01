require 'uri'

module VagrantPlugins
  module GSAuth
    class ExpandGSUrls
      def initialize(app, _)
        @app = app
      end

      def call(env)
        env[:box_urls].map! do |url_string|
          url = URI(url_string)

          if url.scheme == 'gs'
            bucket = url.host
            key = url.path[1..-1]
            raise Errors::MalformedShorthandURLError, url: url unless bucket && key
            next "https://storage.cloud.google.com/#{bucket}/#{key}"
          end

          url_string
        end

        @app.call(env)
      end
    end
  end
end
