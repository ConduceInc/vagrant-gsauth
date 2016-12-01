#!/usr/bin/env ruby

require 'bundler/setup'
require 'googleauth'
require 'google/apis/storage_v1'

require_relative 'support'

ROOT = Pathname.new(File.dirname(__FILE__))

svc = Google::Apis::StorageV1::StorageService.new
svc.authorization = Google::Auth.get_application_default(SCOPES)
svc.insert_bucket(PROJECT, Google::Apis::StorageV1::Bucket.new(name: BUCKET))

box_file = File.open(ROOT + Pathname.new("box/#{BOX_BASE}.box"))
box_obj = svc.insert_object(BUCKET, name: "#{BOX_BASE}.box",
                                    upload_source: box_file,
                                    content_type: 'application/x-gzip')

metadata_string = File.read(ROOT + Pathname.new("box/#{BOX_BASE}")) % {
  bucket: BUCKET,
  box_url: "https://storage.googleapis.com/#{BUCKET}/#{BOX_BASE}.box"
}

svc.insert_object(BUCKET, name: BOX_BASE,
                          upload_source: StringIO.new(metadata_string),
                          content_type: 'application/json')

box_obj.self_link
