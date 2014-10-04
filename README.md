static-sprockets-tent
=====================

Tent authentication component for [static-sprockets](https://github.com/jvatic/static-sprockets).

## Usage

```ruby
# Gemfile
gem 'static-sprockets', :git => 'git://github.com/jvatic/static-sprockets.git', :branch => 'master'
gem 'static-sprockets-tent', :git => 'git://github.com/jvatic/static-sprockets-tent.git', :branch => 'master', :require => false
```

```ruby
# config.rb
require 'static-sprockets'
StaticSprockets.configure(
  :asset_roots => ["./assets"],
  :asset_types => %w( javascripts stylesheets ),
  :layout => "./layout.html.erb",
  :layout_output_name => 'application.html',
  :output_dir => "./build",
  :url => ENV['URL'], # redirect_uri is {url}/auth/tent/callback
  :tent_config => {
    :name => "My Tent App",
    :description => "Description of my Tent app",
    :display_url => "Display URL for my Tent app",
    :read_types => %w(), # Array of post types my app needs read-only access to
    :write_types => %w(), # Array of post types my app needs write access to
    :scopes => %w( permissions ) # Array of scopes my app needs
  },
  :tent_config_db_path => File.join(File.expand_path(File.join(__FILE__, "..")), "db") # directory to store Tent data
)

StaticSprockets.app_config do |app|
  require 'static-sprockets-tent'
  StaticSprocketsTent::App.attach_to_app(app)
end
```

```ruby
# config.ru
require 'bundler'
Bundler.require

require './config'

require 'static-sprockets/app'
map '/' do
  use Rack::Session::Cookie,  :key => 'drop.session',
                              :expire_after => 2592000, # 1 month
                              :secret => ENV['SESSION_SECRET'] || SecureRandom.hex
  run StaticSprockets::App.new
end
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
