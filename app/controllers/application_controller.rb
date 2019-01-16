# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_forgery_protection only: %i[upload]

  def home; end

  def upload
    Recording.create!(audio: params[:audio])
    render json: 'OK'
  end
end
