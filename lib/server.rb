
require 'ri_config'
require 'filesystem'

require 'sinatra/base'
require 'json'

$config = RIConfig.new(File.join(File.dirname(__FILE__), '..', 'config.yml'))

Filesystem.init $config

class DirImage < Sinatra::Base

  set :views, File.join(File.dirname(__FILE__), '..', 'views')
  set :public_folder, File.join(File.dirname(__FILE__), '..', 'public')

  configure :production do
    require 'sinatra-xsendfile'
    helpers Sinatra::Xsendfile
    Sinatra::Xsendfile.replace_send_file!
  end

  configure :development do
    require 'sinatra/reloader'
    register Sinatra::Reloader
  end

  get '/' do
    path = params[:path] || '/'
    @directory = Directory.new(path)

    erb :index
  end

  get '/thumbs/' do
    path = params[:path] || '/'
    image = Image.new(path)
    send_file image.thumbnail_path
  end

  get '/files/' do
    path = params[:path] || '/'
    image = Image.new(path)
    send_file image.real_path.to_s
  end

  get '/images/' do
    path = params[:path] || '/'

    @image        = Image.new(path)

    erb :images
  end
end