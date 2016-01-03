require 'sinatra' 
require 'sinatra/activerecord'
require 'sinatra/flash'

enable :sessions

set :database, "sqlite3:micro_blog_db.sqlite3"

require './models'

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
	@title = 'Home'
	erb :home
end

get '/sign_in' do
	erb :sign_in
end

get '/sign_up' do
	erb :sign_up
end



post '/login' do
	@title = 'Login'
	@user = User.where(username: params[:username]).first

	if @user.nil?
		flash[:alert] = 'Bad News!'
		redirect '/sign_in_failed'
	else
		if @user.password == params[:password]
			flash[:notice] = 'Congratulations!'
			session[:user_id] = @user.id
			current_user
			redirect '/profile'
		else
			redirect '/sign_in_failed'
		end
	end
end

post '/sign_up' do
	@title = 'sign_up'
	if @user.nil?
			User.create(username: params[:username], password: params[:password], email: params[:email], zipcode: params[:zipcode] )
			flash[:notice] = 'Congratulations!'		
			redirect '/edit_profile'
	else
		flash[:alert] = 'The username: #{params[:username] has been taken'
		redirect '/sign_up_failed'
	end
		@user = User.where(username: params[:username]).first
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
	@title = 'You are signed in!'
	# @followees = Follow.where(follower_id: session[:session_user_id])
	erb :success
end

get '/profile' do
	@title = 'Your Profile'
	@user = User.find(session[:user_id])
	@posts = Post.where(user_id: session[:session_user_id])
	erb :profile
end


get '/sign_out' do
	session.clear
	erb :home
end

post '/post' do
	@title = 'Your Profile'
	if params[:post] != ""
		Post.create(user_id: session[:session_user_id], content: params[:post])
	end
	redirect back
end



get '/edit_profile' do
	erb :edit_profile
end

post '/edit_profile' do
	@title = 'Edit Your Profile'
    current_user
	Profile.create(fname: params[:fname], city: params[:city], birthday: params[:birthday], lname: params[:lname], user_id: "#{@current_user.id}")
	erb :edit_profile
end



get '/profile' do
	current_user
	erb :profile
end


