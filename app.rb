require 'sinatra' 
require 'sinatra/activerecord'
require 'sinatra/flash'
require './models'

set :database, "sqlite3:micro_blog_db.sqlite3"
enable :sessions

# define current user

def current_user
	if session[:user_id]
		@current_user = User.find(session[:user_id])
	end
end

# routes

get '/' do
	erb :home
end

get '/sign_in' do
	erb :sign_in
end

post '/sign_in' do
	@user = User.where(username: params[:username]).first
		if @user.password == params[:password]
			session[:user_id] = @user.id
			current_user
			erb :profile
		else
			redirect '/sign_in_failed'
		end
end

get '/sign_up' do
	erb :sign_up
end


post '/sign_up' do
	@user = User.where(username: params[:username]).first
	if @user.nil?
		@user = User.create(username: params[:username], password: params[:password], email: params[:email], zipcode: params[:zipcode] )
		flash[:notice] = 'Congratulations! You have successfully signed up and edited your profile.'	
		@profile = Profile.create(fname: params[:fname], city: params[:city], birthday: params[:birthday], lname: params[:lname])
		@user.profile = @profile
		@user.save
		erb :edit_profile
	else
		flash[:alert] = 'The username: #{params[:username] has been taken'
		redirect '/sign_up_failed'
	end
		session[:user_id] = @user.id
		current_user
		erb :edit_profile
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

post '/new_profile' do
  current_user
  params.each do |type, value|
    if value == ""
      params.except!(type)
      puts params
    else
    @current_user.profile.update({type => value})
    end
  end
  redirect '/profile'
end

post '/delete_profile' do
	current_user
	current_user.destroy
	erb :home
end

get '/users' do
	@title = 'Users'
	@users = User.all
	erb :users
end

get '/:username' do
	@user = User.find_by(username: params[:username])
	# @followers = Follow.where(user_id: @user.id)
	@profile = Profile.find_by(user_id: @user.id)
	@posts = Post.where(user_id: @user.id)
	# @follow = false
	# @followers.each do |follower|
	# 	if follower.follower_id == session[:session_user_id]
	# 		@follow = true
	# 	end 
	erb :user
end





