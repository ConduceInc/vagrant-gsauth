require 'log4r'
require 'net/http'
require 'uri'

require 'googleauth'
require 'google/apis/storage_v1'

module VagrantPlugins
  module GSAuth
    module Util
      MEDIA_URL_MATCHER = %r{
        ^\/download\/storage\/v1\/b\/   # Literal string '/download/storage/v1/b/'
        (?<bucket>[[:alnum:]_\-]+)      # Sequence of alphnumeric characters plus _ and -
        \/o\/                           # Literal string '/o/'
        (?<key>[[:alnum:]\-_]+)         # Next sequence of alphnumeric characters plus _ and -
      }x

      def self.storage_svc
        svc = Google::Apis::StorageV1::StorageService.new
        scopes = ['https://www.googleapis.com/auth/devstorage.read_only']
        svc.authorization = Google::Auth.get_application_default(scopes)
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

        storage_svc.get_object(bucket, key) if bucket && key
      end

      def self.authorization_header
        auth_headers = {}
        storage_svc.authorization.apply(auth_headers)
      end
    end
  end
end
