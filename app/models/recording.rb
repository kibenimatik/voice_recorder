# frozen_string_literal: true

# == Schema Information
#
# Table name: recordings
#
#  id         :integer          not null, primary key
#  audio_data :text
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Recording < ApplicationRecord
  include AudioUploader[:audio]
end
