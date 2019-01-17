# heroku plugins:install heroku-cli-oauth
# heroku authorizations:create -d "Restart app token"

namespace :heroku do
  # rake heroku:auto_restart TIME_PERIOD=300
  desc 'Automatically restart heroku instance if exception occures'
  task auto_restart: :setup do
    log_session = heroku.log_session.create(@app_name, { tail: true, dyno: @proc_name})
    log('Starting to hunt for exception...')
    stream log_session['logplex_url'] do |chunk|
      log_string = chunk.split("\n").grep(/ActiveRecord\:\:StatementInvalid/).last
      data = log_string.to_s.match(/(?<time>[\d\-T\:\.\+]{32})\s.+\[(?<name>[\w\d\.]+)\]/)

      restart!(data[:name]) if data
    end
  end

  task :setup do
    @token = ENV['TOKEN']
    @app_name = ENV['APP_NAME'].presence || 'cryptic-plateau-74869'
    @proc_name = ENV['PROC_NAME'].presence || 'web'
    @time_period = (ENV['TIME_PERIOD'].presence || 5.minutes).to_i
  end
end

def heroku
  @heroku ||= PlatformAPI.connect_oauth(@token)
end


def restart!(dyno_name)
  dyno = heroku.dyno.info(@app_name, dyno_name)
  return if !dyno
  log("Dyno: #{dyno_name}")
  dyno_restarted_at = Time.parse(dyno['updated_at'])
  dyno_uptime = Time.now.utc - dyno_restarted_at
  log("uptime: #{dyno_uptime}")

  if dyno_uptime > @time_period
    log("Restarting ...")
    heroku.dyno.restart(@app_name, dyno_name) unless ENV.key?('DRYRUN')
  else
    log("Restart skipped")
  end
  log('')
end

def log(message)
  puts message
end

def stream(url)
  uri = URI(url)

  Net::HTTP.start(uri.host, uri.port, use_ssl: true) do |http|
    request = Net::HTTP::Get.new uri

    http.request(request) do |response|
      response.read_body do |chunk|
        yield chunk
      end
    end
  end
end
