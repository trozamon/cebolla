source 'https://rubygems.org'

ruby '3.2.9'

gem 'rails', '~> 8.1.0' # rails obvi
gem 'devise' # authentication
gem 'haml' # better templates
gem 'importmap-rails'
gem 'money-rails' # nice money handling
gem 'pg' # database
gem 'prawn' # PDF generation
gem 'puma' # app server
gem 'sass-rails', '>= 6' # Use SCSS for stylesheets

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
  gem 'listen'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen'
end

group :test do
  # Adds support for Capybara system testing and selenium driver
  gem 'capybara', '>= 2.15'
  gem 'selenium-webdriver'
end
