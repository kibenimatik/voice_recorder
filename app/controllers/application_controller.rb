# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_forgery_protection only: %i[upload]

  # rescue_from ActiveRecord::StatementInvalid, with: :restart

  def home; end

  def upload
    Recording.create!(audio: params[:audio])
    render json: 'OK'
  end

  def r5t
    raise ActiveRecord::StatementInvalid
  end

  def dyno
    heroku = PlatformAPI.connect_oauth('9368e5db-79dc-4df1-bb10-0117cafb09e6')
    @dyno = heroku.dyno.list('cryptic-plateau-74869').first
  end

  private

  def restart
    heroku_restart
    super
    # redirect_to dyno_path, notice: 'restarting ...'
  end

  def heroku_restart
    heroku = PlatformAPI.connect_oauth('9368e5db-79dc-4df1-bb10-0117cafb09e6')
    dyno = heroku.dyno.list('cryptic-plateau-74869').first
    heroku.dyno.restart_all 'cryptic-plateau-74869' if Time.zone.now - Time.parse(dyno['updated_at']) > 1.minute
  end
end
