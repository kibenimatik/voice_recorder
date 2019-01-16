# frozen_string_literal: true

class RecordingsController < ResourceController
  private

  def resource_scope
    Recording
  end

  def resource_params
    params.fetch(:recording, {})
  end
end
