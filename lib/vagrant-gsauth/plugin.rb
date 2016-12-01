begin
  require 'vagrant'
rescue LoadError
  raise 'The Vagrant S3Auth plugin must be run within Vagrant.'
end

require_relative 'errors'
require_relative 'extension/downloader'

module VagrantPlugins
  module GSAuth
    class Plugin < Vagrant.plugin('2')
      Vagrant.require_version('>= 1.5.1')

      name 'gsauth'

      description <<-DESC
        Use versioned Vagrant boxes with Google Cloud authentication.
      DESC

      action_hook(:gs_urls, :authenticate_box_url) do |hook|
        require_relative 'middleware/expand_gs_urls'
        hook.prepend(ExpandGSUrls)
      end
    end
  end
end
