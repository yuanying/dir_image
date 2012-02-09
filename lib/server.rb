
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
    @indexes = []
    Filesystem.config.image_dirs.each_with_index do |dir, index|
      @indexes << [File.basename(dir), index]
    end
    erb :index
  end

  get '/dirs/:index' do
    path        = params[:path] || '/'
    @index      = params[:index]
    @directory  = Directory.get(@index, path)
    @back_url   = path == '/' ? '/' : @directory.parent.url

    erb :dirs
  end

  get '/thumbs/:index' do
    path    = params[:path] || '/'
    @index  = params[:index]
    image = Image.get(@index, path)

    image.create_thumbnail
    send_file image.thumbnail_path
  end

  get '/files/:index' do
    path    = params[:path] || '/'
    @index  = params[:index]
    image = Image.get(@index, path)
    send_file image.real_path.to_s
  end

  get '/images/:index' do
    path    = params[:path] || '/'
    @index  = params[:index]

    @image = Image.get(@index, path)

    erb :images
  end
end