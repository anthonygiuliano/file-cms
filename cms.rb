require 'sinatra'
require 'sinatra/reloader'
require "tilt/erubis"

configure do
  enable :sessions
  set :session_secret, 'secret'
end

helpers do
  def root
    File::expand_path('..', __FILE__)
  end
end

get '/' do
  @files = Dir.glob(root + '/data/*').map { |file| File::basename(file) }
  erb :index, layout: :layout
end

get "/:filename" do
  file_path = root + "/data/" + params[:filename]

  if File.exist?(file_path)
    headers["Content-Type"] = "text/plain"
    File.read(file_path)
  else
    session[:message] = "#{params[:filename]} does not exist."
    redirect "/"
  end
end
