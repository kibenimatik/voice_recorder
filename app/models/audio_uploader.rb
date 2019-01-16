# frozen_string_literal: true

class AudioUploader < Shrine
  plugin :activerecord
  plugin :logging, logger: Rails.logger
end
