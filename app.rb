require 'sinatra' 
require 'sinatra/activerecord'
require 'sinatra/flash'

enable :sessions

set :database, "sqlite3:micro_blog_db.sqlite3"

require './models'

# define current user and call it, so it can be used going forward for each session

def current_user
  if session[:user_id]
    User.find(session[:user_id])  
  else
    nil
  end
end

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end

get '/' do
	erb :home
end

get '/sign_in' do
	erb :sign_in
end

get '/sign_up' do
	erb :sign_up
end

post '/login' do
	@user = User.where(username: params[:username]).first
		if @user.password == params[:password]
			flash[:notice] = 'Congratulations!'
			session[:user_id] = @user.id
			current_user
			redirect '/profile'
		else
			redirect '/sign_in_failed'
		end
end


post '/sign_up' do
	@user = User.where(username: params[:username]).first
	if @user.nil?
		@user = User.create(username: params[:username], password: params[:password], email: params[:email], zipcode: params[:zipcode] )
		flash[:notice] = 'Congratulations!'	
		@profile = Profile.create(fname: params[:fname], city: params[:city], birthday: params[:birthday], lname: params[:lname])
		@user.profile = @profile
		redirect '/edit_profile'
	else
		flash[:alert] = 'The username: #{params[:username] has been taken'
		redirect '/sign_up_failed'
	end
		session[:user_id] = @user.id
		current_user
		redirect '/edit_profile'
end

get '/sign_up_failed' do
	erb :sign_up_failed
end

get '/success' do
	erb :success
end

get '/sign_in_failed' do
	erb :sign_in_failed
end

post '/login_success' do
	erb :success
end


get '/sign_out' do
	session.clear
	erb :home
end

post '/post' do
	if params[:post] != ""
		Post.create(user_id: session[:session_user_id], content: params[:post])
	end
	redirect back
end

get '/profile' do
	erb :profile
end

post '/profile' do
	current_user
	erb :profile
end

get '/edit_profile' do
	erb :edit_profile
end

post '/edit_profile' do
    current_user
	current_user.profile.update(fname:params[:fname], lname:params[:lname], city:params[:city], birthday:params[:birthday])
	erb :edit_profile
end





