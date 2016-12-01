require 'vagrant'

module VagrantPlugins
  module GSAuth
    module Errors
      class VagrantGSAuthError < Vagrant::Errors::VagrantError
        error_namespace('vagrant_s3auth.errors')
      end

      class UnknownBucketError < VagrantGSAuthError
        error_key(:unknown_bucket)
      end

      class MalformedShorthandURLError < VagrantGSAuthError
        error_key(:malformed_shorthand_url)
      end
    end
  end
end
