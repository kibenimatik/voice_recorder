# frozen_string_literal: true

class ApplicationJob < ActiveJob::Base
  retry_on ActiveRecord::Deadlocked
  retry_on ActiveRecord::StatementInvalid

  discard_on ActiveJob::DeserializationError
end
