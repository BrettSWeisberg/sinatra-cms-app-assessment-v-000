
class ProjectsController < ApplicationController

  get '/projects/new' do # create a new project
    erb :'/projects/new_project'
  end

  post '/projects' do #create a new project
    @client = Client.find(session[:client_id])
  #  binding.pry
    if !params[:name].empty? && !params[:description].empty? && !params[:project_completion].empty? && logged_in?
      @project = Project.create(client_id: @client.id, name: params[:name], description: params[:description], project_completion: params[:project_completion])
      redirect "/projects/#{@project.id}"
    else
      redirect '/login'
    end
  end

  get '/projects/:id' do #find/show
    if logged_in?
      @project = Project.find(params[:id])
      erb :'/projects/show_project'
    else
      redirect '/login'
    end
  end

  get '/projects/:id/edit' do #loads edit page
    if logged_in?
      @project = Project.find_by(id: params[:id])
      erb :'/projects/edit_project'
    else
      redirect '/login'
    end
  end

  post '/projects/:id' do #updates the entry based on the edit route
    @project = Project.find(params[:id])

    if !params[:name].empty? && !params[:description].empty? && !params[:project_completion].empty? && logged_in? && current_user.id == @project.client_id
        @project.update(name: params[:name],description: params[:description], project_completion: params[:project_completion])
        redirect "/projects/#{@project.id}"
    else
      redirect "/projects/#{@project.id}/edit"
    end
  end

  delete '/projects/:id/delete' do
  #  binding.pry
    @project = Project.find_by(id: params[:id])
    if current_user.id == @project.client_id && logged_in?
      @project.delete
      redirect '/login'
      
    end
  end

end
