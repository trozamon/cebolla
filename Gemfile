source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '3.0.5'

gem 'rails', '~> 6' # rails obvi
gem 'devise' # authentication
gem 'haml' # better templates
gem 'money-rails' # nice money handling
gem 'pg' # database
gem 'pghero' # database analytics
gem 'prawn' # PDF generation
gem 'puma' # app server
gem 'sass-rails', '>= 6' # Use SCSS for stylesheets
gem 'webpacker', '~> 4.0' # Transpile app-like JavaScript
gem 'turbolinks', '~> 5' # Fast navigation

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.4.2', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platforms: [:mri, :mingw, :x64_mingw]
  gem 'faker'
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
  # Easy installation and use of web drivers to run system tests with browsers
  gem 'webdrivers'
end
