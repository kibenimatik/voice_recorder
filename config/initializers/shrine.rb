# frozen_string_literal: true

require 'shrine/storage/s3'

s3_options = {
  bucket: Rails.application.credentials.aws[:s3_bucket_name],
  access_key_id: Rails.application.credentials.aws[:access_key_id],
  secret_access_key: Rails.application.credentials.aws[:secret_access_key],
  region: 'us-east-1'
}

Shrine.storages = {
  cache: Shrine::Storage::S3.new(prefix: 'cache', **s3_options),
  store: Shrine::Storage::S3.new(public: true, **s3_options)
}

Shrine.plugin :activerecord
Shrine.plugin :pretty_location
