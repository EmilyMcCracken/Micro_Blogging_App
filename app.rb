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
	@posts = Post.all
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
			redirect '/profile'
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
		current_user.posts << Post.create(content: params[:post])
	end
	redirect '/profile'
end

get '/profile' do
	current_user
	@posts = current_user.posts
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
	@users = User.all
	erb :users
end

get '/user' do
	@users = User.all
	erb :user
end

get '/:username' do
	@user = User.find_by(username: params[:username])
	@profile = Profile.find_by(user_id: @user.id)
	@posts = Post.where(user_id: @user.id)
	erb :user
end

post '/post' do
	@title = 'Your Profile'
	if params[:post] != ""
		Post.create(content: params[:post])
	end
	redirect back
end


def follow_method
  if current_user 
    current_user
    User.find(params[:followID]).followers.push(User.find(@user.id))
  end
end

post '/follow_method' do
  follow_method
  current_user
  erb :profile
end

get '/follow_user' do
  current_user
  erb :users
end




