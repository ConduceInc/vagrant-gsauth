require 'uri'

require 'vagrant/util/downloader'
require 'vagrant-gsauth/util'
require 'google/apis/errors'

GSAuth = VagrantPlugins::GSAuth

module Vagrant
  module Util
    class Downloader
      def gsauth_download(options, subprocess_options, &data_proc)
        # The URL sent to curl is always the last argument. We have to rely
        # on this implementation detail because we need to hook into both
        # HEAD and GET requests.
        url = options.last
        gs_object = GSAuth::Util.get_object(url)
        return unless gs_object

        @logger.info("gsauth: Discovered GS URL: #{@source}")
        @logger.debug("gsauth: Bucket: #{gs_object.bucket}")
        @logger.debug("gsauth: Object: #{gs_object.name}")

        url.replace(gs_object.media_link)
        @logger.debug("gsauth: Media download link: #{gs_object.media_link}")

        auth_headers = GSAuth::Util.authorization_header

        options.insert(0, *auth_headers.map { |k, v| ['-H', "#{k}: #{v}"] }.flatten)
        @logger.debug("gsauth: curl options: #{options}")

        _execute_curl(options, subprocess_options, &data_proc)
      rescue Errors::DownloaderError => e
        if e.message =~ /403 Forbidden/
          e.message << "\n\n"
          e.message << I18n.t('vagrant_gsauth.errors.box_download_forbidden',
            bucket: gs_object && gs_object.bucket.name)
        end
        raise
      rescue Google::Apis::Error => e
        raise Errors::DownloaderError, message: e
      end

      def execute_curl_with_gsauth(options, subprocess_options, &data_proc)
        url = options.last
        if url.include?('storage.cloud.google')
          # If the URL was expanded attempt a gsauth download first.
          # Needed for grabbing metadata
          gsauth_download(options, subprocess_options, &data_proc)
        end

        _execute_curl(options, subprocess_options, &data_proc)
      rescue Errors::DownloaderError => e
        @ui.clear_line if @ui

        gsauth_download(options, subprocess_options, &data_proc) || (raise e)
      end

      alias _execute_curl execute_curl
      alias execute_curl execute_curl_with_gsauth
    end
  end
end
