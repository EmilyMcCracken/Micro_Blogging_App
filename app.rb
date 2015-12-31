require 'sinatra' 
require 'sinatra/activerecord'
require 'sinatra/flash'

enable :sessions

set :database, "sqlite3:micro_blog_db.sqlite3"

require './models'

get '/' do
	@title = 'Home'
	erb :home
end
post '/login' do
	@title = 'Login'
	@user = User.where(username: params[:username]).first

	if @user.nil?
		flash[:alert] = 'Bad News!'
		redirect '/failed'
	else
		if @user.password == params[:password]
			flash[:notice] = 'Congratulations!'
			session[:session_userid] = @user.id
			session[:session_username] = @user.username
			redirect '/login_success'
		else
			redirect '/failed'
		end
	end
end

post '/signup' do
	@title = 'Signup'
	@user = User.where(username: params[:username]).first
	if @user.nil?
			@user = User.create(username: params[:username], password: params[:password])
			# @profile = Profile.create(email: params[:email], user_id: @user.id)
			flash[:notice] = 'Congratulations!'
			session[:session_user_id] = @user.id
			session[:session_username] = @user.username
			redirect 'login_success'
	else
		flash[:alert] = 'The username: #{params[:username] has been taken'
		redirect '/failed'
	end
end

get '/login_success' do
	@title = 'You are signed in!'
	# @followees = Follow.where(follower_id: session[:session_user_id])
	erb :success
end
get '/failed' do
	@title = 'Login / Signup Failed'
	flash[:alert] = 'Bad News!'
	erb :home
end