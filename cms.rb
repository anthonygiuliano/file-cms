require 'sinatra'
require 'sinatra/reloader'
require "tilt/erubis"

helpers do
  def root
    File::expand_path('..', __FILE__)
  end
end

get '/' do
  @files = Dir.glob(root + '/data/*').map { |file| File::basename(file) }
  erb :index, layout: :layout
end
