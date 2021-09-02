threads_count = Integer(ENV['RAILS_MAX_THREADS'] || 5)
threads threads_count, threads_count

if ENV.key?('PORT')
  port ENV['PORT']
else
  port 5000
end

if ENV.key?('RACK_ENV')
  environment ENV['RACK_ENV']
else
  environment 'production'
end
