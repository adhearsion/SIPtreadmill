require 'rubygems'
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__),"..","lib"))
require 'sinatra'
require 'json'
require 'omniauth'
require 'omniauth-github'
require 'omniauth-facebook'
require 'omniauth-twitter'
require 'omniauth-att'

class SinatraApp < Sinatra::Base
  configure do
    set :logging, true
    set :sessions, true
    set :inline_templates, true
  end
  configure :production do
    require 'newrelic_rpm'
  end

  def self.db
    @db ||= {}
  end

  def db
    self.class.db
  end
  
  use OmniAuth::Builder do
    provider :github, (ENV['GITHUB_CLIENT_ID']||'b6ce639ebd5618ca4d52'), (ENV['GITHUB_CLIENT_SECRET']||'ef8b9abe468c2021d1e829f566091446375ea181')
    provider :facebook, (ENV['FACEBOOK_CLIENT_ID']||'290594154312564'),(ENV['FACEBOOK_CLIENT_SECRET']||'a26bcf9d7e254db82566f31c9d72c94e')
    provider :twitter, 'cO23zABqRXQpkmAXa8MRw', 'TwtroETQ6sEDWW8HEgt0CUWxTavwFcMgAwqHdb0k1M'
    provider :att, ENV['ATT_CLIENT_ID'], ENV['ATT_CLIENT_SECRET'],
             :site => ENV['ATT_BASE_DOMAIN'],
             :callback_url => "#(ENV['BASE_DOMAIN'] || 'http://localhost:9393')/auth/att/callback",
             :scope => 'profile'
  end
  
  get '/' do
    erb :index
  end


get '/auth/:provider/callback' do
    db[:access_token] = request.env['omniauth.auth']['credentials']['token']
    @access_token = db[:access_token]
    erb "<h1>#{params[:provider]}</h1>
         <pre>#{JSON.pretty_generate(request.env['omniauth.auth'])}</pre>"
  end
  
  get '/auth/failure' do
    erb "<h1>Authentication Failed:</h1><h3>message:<h3> <pre>#{params}</pre>"
  end
  
  get '/auth/:provider/deauthorized' do
    erb "#{params[:provider]} has deauthorized this app."
  end
  
  get '/protected' do
    throw(:halt, [401, "Not authorized\n"]) unless db[:access_token]
    erb "<pre>#{request.env['omniauth.auth'].to_json}</pre><hr>
        <br />
         <a href='/logout'>Logout</a>"
  end
  
  get '/doc' do
    erb :docs
  end
  
  get '/logout' do
    session[:authenticated] = false
    db[:access_token] = nil
    redirect auth_url + "/logout?redirect_uri=#{CGI.escape(base_domain)}"
  end
  
  get '/env' do
    puts ENV.inspect
    halt 401
  end
  
  def auth_url
    (ENV['ATT_BASE_DOMAIN'] || 'https://auth.tfoundry.com')
  end
  

  def base_domain
    return  'http://localhost:9393'
    # return ENV['BASE_DOMAIN'] if ENV['BASE_DOMAIN']
    # case ENV['RACK_ENV']
    # when 'production'
    #   "https://omniauth-att-example.herokuapp.com"
    # else
    #   'http://localhost:9393'
    # end
  end

end

SinatraApp.run! if __FILE__ == $0

__END__

@@ layout
<html>
  <head>
    <link href='http://twitter.github.com/bootstrap/1.4.0/bootstrap.min.css' rel='stylesheet' />
  </head>
  <body>
    <div class='container'>
      <div class="header">
        <ul>
          <li><a href="/">home</a></li>
          <li><a href="/doc">docs</a></li>
          <li><a href="/logout">logout</a></li>
        </ul>
      </div>
      <div class='content'>
        <%= yield %>
      </div>
      
    </div>
  </body>
</html>

@@index
  <% if @access_token %>
  <h4>Hurray! You already have an access token</h4>
  <%= @access_token %>
  Get your profile <a href='/protected'>here</a>
  <% else %>
  <% url = request.env['REQUEST_URI'] %>
  <% url = url[0..-2] if url[-1] == '/' %>
  
  <a href='<%= url %>/auth/github'>Login with Github</a><br>
  <a href='<%= url %>/auth/facebook'>Login with facebook</a><br>
  <a href='<%= url %>/auth/twitter'>Login with twitter</a><br>
  <a href='<%= url %>/auth/att'>Login with att-foundry</a>
  <% end %>

@@docs
<h2>Authentication docs page</h2>
<p>This is a sample application that shows how the authentication mechanism works.</p>
<p>It is incredibly simple and mimicks the OAuth2 flow. Firstly, the application must have
a <code>client_id</code> and a <code>client_secret</code>. When the application wants to get 
an authenticated user, they can simply redirect the user with their <code>client_id</code> and a <code>redirect_uri</code> to
the foundry auth page at: #{auth_url}/login.
The foundry auth will take care of the login and redirecting the user back to the <code>redirect_uri</code> (provided it matches the one that the application registered) with a <code>request_token</code>. </p>

<p>It is then up to the application to respond with the <code>request_token</code> to <code>POST</code> to <code>#{auth_url}/auth</code> with the <code>request_token</code>, their <code>client_id</code> and their <code>client_secret</code>, they will get an <code>auth_hash</code> with the user's credentials, uid, some profile information and more. The entire contents of the <code>auth_hash</code> are still up for debate, but will definitely contain the user's info.</p>

<p>When using the ruby language, they can use the Foundry's (soon-to-be) open-sourced <code>omniauth-att</code> library.</p>

<h2>Summary</h2>

<p><code>application -> 302 #{auth_url}/login</code></p>
<p><code>#{auth_url} 302 -> application/callback?request_token=code</code></p>
<p><code>application -> POST #{auth_url}/auth?code=code -> {"access_token":"token"}</code></p>
<p><code>application -> POST #{auth_url}/auth?code=code -> {"access_token":"token"}</code></p>

@@readme
## To deploy to heroku
    
     heroku create --stack cedar
     git push heorku master
     heroku config:add ATT_CLIENT_ID=asdfsdf ATT_CLIENT_SECRET=gggg  ATT_REDIRECT_URI=https://yourapp.heroku.com/auth/att/callback 
     heroku open
   
# config

If you would like to also have the github and facebook samples work, you will need to get app credentials and update the env.

    base_domain = heroku info|grep Web|awk {'print $3'}

    heroku config:add GIHUB_OAUTH_CLIENT_ID=xx
    heroku config:add GIHUB_OAUTH_CLIENT_SECRET=cv

    heroku config:add FACEBOOK_OAUTH_CLIENT_ID=fdfdf
    heroku config:add FACEBOOK_OAUTH_CLIENT_SECRET=asdsad
