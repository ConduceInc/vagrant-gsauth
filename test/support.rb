require 'http'

PROJECT = ENV['VAGRANT_GSAUTH_PROJECT'].freeze
BUCKET = ENV['VAGRANT_GSAUTH_BUCKET'].freeze
BOX_BASE = ENV['VAGRANT_GSAUTH_BOX_BASE'].freeze
SCOPES = ['https://www.googleapis.com/auth/devstorage.read_write'].freeze
