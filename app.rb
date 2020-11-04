require 'sinatra/base'
require_relative 'lib/message_board'

class Blog_App < Sinatra::Base
  enable :sessions, :method_override

  get '/' do
    erb :index
  end

  post '/messages' do
    session[:username] = params[:username]
    redirect '/message_board'
  end

  get '/message_board' do
    @username = session[:username]
    @messages = Message_Board.all
    erb :message_board
  end

  get '/add_message' do
    erb :add_message
  end

  post '/add_message' do
    message = params[:message] + " -- #{session[:username]}"
    Message_Board.add(message)
    redirect '/message_board'
  end

  delete '/messages/:id' do
    Message_Board.delete(id: params[:id])
    redirect '/message_board'
  end
end