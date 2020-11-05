require 'sinatra/base'
require 'sinatra/flash'
require_relative 'lib/chitter_board'
require_relative 'lib/user'
require_relative 'lib/database_connection_setup'

class Chitter < Sinatra::Base
  enable :sessions, :method_override
  register Sinatra::Flash

  get '/' do
    erb :index
  end

  # Post for logging into existing account
  post '/chitter' do
    if User.check_login(username: params[:username], password: params[:password])
      #session[:user_id] = User.current_user
      redirect '/chitter_board'
    else
      flash[:pword_notice] = 'Incorrect username or password!'
      redirect '/'
    end
  end

  # Post for creating new account
  post '/chitter/new_user' do
    if User.create_user(username: params[:username], password: params[:password]) == false
      #session[:user_id] = User.current_user
      flash[:username_notice] = 'This username is taken!'
      redirect '/'
    else
      redirect '/chitter_board'
    end
  end

  # Get for main chitter view
  get '/chitter_board' do
    @user = User.find_user(id: User.current_user)
    @messages = ChitterBoard.all
    erb :chitter_board
  end

  # Get for add peep view
  get '/add_peep' do
    erb :add_peep
  end

  # Post for adding peep
  post '/add_peep' do
    peep = params[:message] + " -- #{session[:username]}"
    ChitterBoard.add(message: peep, user_id: User.current_user)
    redirect '/chitter_board'
  end

  # Delete method for deleting peeps
  delete '/chitter/:id' do
    ChitterBoard.delete(id: params[:id])
    redirect '/chitter_board'
  end
end