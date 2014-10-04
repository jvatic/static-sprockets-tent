require 'static-sprockets-tent/app/middleware'

module StaticSprocketsTent
  class App
    class AccessControl < ::StaticSprockets::App::AccessControl
    end

    class RenderView < ::StaticSprockets::App::RenderView
    end

    class CacheControl < Middleware
      def action(env)
        env['response.headers'] ||= {}
        env['response.headers'].merge!(
          'Cache-Control' => @options[:value].to_s,
          'Vary' => 'Cookie'
        )
        env
      end
    end

    def self.attach_to_app(app)
      require 'omniauth-tent'
      require 'static-sprockets'
      require 'static-sprockets-tent/app/authentication'
      require 'static-sprockets-tent/model'

      Model.new

      (::StaticSprockets.config[:view_roots] ||= []).push(
        File.expand_path(File.join(File.dirname(__FILE__), "views")))

      app.middleware Authentication, :except => [%r{\A/auth/tent(/callback)?}]
      if ::StaticSprockets.config[:tent_config]
        tent_config = ::StaticSprockets.config[:tent_config]
        app.match %r{\A/auth/tent(/callback)?} do |b|
          b.use OmniAuth::Builder do
            provider :tent, {
              :get_app => AppLookup,
              :on_app_created => AppCreate,
              :app => {
                :name => tent_config[:name],
                :description => tent_config[:description],
                :url => tent_config[:display_url],
                :redirect_uri => "#{::StaticSprockets.config[:url].to_s.sub(%r{/\Z}, '')}/auth/tent/callback",
                :read_types => tent_config[:read_types],
                :write_types => tent_config[:write_types],
                :scopes => tent_config[:scopes]
              }
            }
          end
          b.use OmniAuthCallback
        end

        app.post '/auth/signout' do |b|
          b.use Signout
        end

        app.get '/config' do |b|
          b.use AccessControl, :allow_credentials => true
          b.use CacheControl, :value => 'no-cache'
          b.use CacheControl, :value => 'private, max-age=600'
          b.use Authentication, :redirect => false
          b.use RenderView, :view => :'config.json', :content_type => "application/json"
        end
      end
    end
  end
end
