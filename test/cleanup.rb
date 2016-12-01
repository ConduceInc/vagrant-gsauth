#!/usr/bin/env ruby

require 'bundler/setup'
require 'googleauth'
require 'google/apis/storage_v1'

require_relative 'support'

svc = Google::Apis::StorageV1::StorageService.new
svc.authorization = Google::Auth.get_application_default(SCOPES)

svc.delete_object(BUCKET, BOX_BASE)
svc.delete_object(BUCKET, "#{BOX_BASE}.box")
sleep 1
svc.delete_bucket(BUCKET)
