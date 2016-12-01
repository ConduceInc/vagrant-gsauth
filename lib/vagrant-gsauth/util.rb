require 'log4r'
require 'net/http'
require 'uri'

require 'googleauth'
require 'google/apis/storage_v1'

module VagrantPlugins
  module GSAuth
    module GSUtil
      MEDIA_URL_MATCHER = /^\/download\/storage\/v1\/b\/(?<bucket>[[:alnum:]_\-]+)\/o\/(?<key>[[:alnum:]\-_]+)/

      def self.storage_svc
        svc = Google::Apis::StorageV1::StorageService.new
        svc.authorization = Google::Auth.get_application_default(["https://www.googleapis.com/auth/devstorage.read_only"])
        svc
      end

      def self.get_object(url)
        url = URI(url)

        if url.scheme == 'gs'
          bucket = url.host
          key = url.path.split('/').last
        elsif match = MEDIA_URL_MATCHER.match(url.path)
          bucket = match['bucket']
          key = match['key']
        else
          components = url.path.split('/').delete_if(&:empty?)
          bucket = components.shift
          key = components.join('/')
        end

        if bucket && key
          self.storage_svc.get_object(bucket, key)
        end
      end

      def self.authorization_header
        auth_headers = {}
        self.storage_svc.authorization.apply(auth_headers)
      end
    end
  end
end
