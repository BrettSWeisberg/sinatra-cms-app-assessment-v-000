require 'rack-flash'

class ClientController < ApplicationController
  use Rack::Flash

  get '/signup' do
   if !logged_in?
     erb :'/clients/new_client' # if they are not logged in have them sign up
   else
     redirect "/clients/:id" # if they are logged in take them to the user home page
   end
 end

  post '/signup' do
    binding.pry
    if !params[:name].empty? && !params[:email].empty? && !params[:password].empty? && Client.find_by(name: name) == nil
        client = Client.create(name: params[:name], email: params[:email], password: params[:password])
        session[:client_id] = client.id
        client.save
        redirect "/clients/:id" # if sign up successful take them to the show page for all proejcts
      else
        redirect "/signup" # if sign up not successful take them back to sign up
    end
  end

  get '/login' do
    if !logged_in?
      erb :'/clients/login' #if not loggged in go to login
    else
      redirect "/clients/:id" #if logged in go to show page
    end
  end

  post '/login' do #recieve login info
    @client = Client.find_by(name: params[:name])
    if @client && @client.authenticate(params[:password])
    session[:client_id] = @client.id
    redirect "/clients/:id"
    else
        redirect "/login"
    end
  end

  get '/logout' do
    session.clear
    redirect "/login"
  end

  get '/clients/:id' do #show page
    #binding.pry
    if logged_in?
      @client = Client.find(session[:client_id])
      erb :'/clients/show_client'
    else
      erb :'/client/login'
    end
  end

  get '/clients/:id/edit' do
    if logged_in?
    #  binding.pry
      @client = Client.find(params[:id])
      erb :'/clients/edit_client'
    else
      redirect "/login"
    end
  end

  post '/clients/:id' do
  #  binding.pry
      @client = Client.find(session[:client_id])
    if !params[:name].empty? && !params[:email].empty? && !params[:password].empty? && logged_in? && current_user.id == @client.id
      @client.update(name: params[:name], email: params[:email], password: params[:password])
      @client.save
      redirect  "/clients/#{@client.id}"
    else
      flash[:message] = "Could not update."
      redirect "/clients/#{@client.id}/edit"
    end
  end
end
