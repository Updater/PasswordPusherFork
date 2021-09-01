source "https://rubygems.org"

ruby ">=2.7.0"

gem "bootsnap", ">= 1.1.0", require: false
gem "coffee-rails", "~> 4.2"
gem "foreman"
gem "high_voltage"
gem "jbuilder", "~> 2.5"
gem "jquery-rails"
gem "json", "~> 2.0" # Legacy carry-over
gem "kramdown", require: false
gem "lograge"
gem "oj"
gem "opentelemetry-exporter-otlp", "0.20.3"
gem "opentelemetry-instrumentation-all", "0.20.1"
gem "opentelemetry-sdk", "1.0.0.rc3"
gem "prometheus-client"
gem "puma"
gem "rack-attack"
gem "rack-cors"
gem "rails", "~> 5.2.0"
gem "rake", "~> 13.0"
gem "sass-rails", "~> 5.0"
gem "sprockets", "~>3.0"
gem "turbolinks", "~> 5"
gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
gem "uglifier", ">= 1.3.0"
gem "vault-rails", require: false

# OSX: ../src/utils.h:33:10: fatal error: "climits" file not found
# From:
# # 1. Install v8 ourselves
# $ brew install v8-315
# # 2. Install libv8 using the v8 binary we just installed
# $ gem install libv8 -v "3.16.14.19" -- --with-system-v8
# # 3. Install therubyracer using the v8 binary we just installed
# $ gem install therubyracer -- --with-v8-dir=/usr/local/opt/v8@315
# # 4. Install the remaining dependencies
# $ bundle install
#gem "therubyracer"

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
  gem "web-console", ">= 3.3.0"
end

group :production do
  gem "pg", "~> 0.21"
  gem "rack-timeout"
  gem "rack-throttle"
end

group :test do
  gem "capybara", ">= 2.15", "< 4.0"
  gem "chromedriver-helper"
  gem "minitest"
  gem "minitest-reporters"
  gem "minitest-rails"
  gem "selenium-webdriver"
end

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "pry-byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "sqlite3", "< 1.4.0"
end
