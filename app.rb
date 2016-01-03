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
			session[:session_userid] = @user.id
			session[:session_username] = @user.username
			redirect 'login_success'
		else
			redirect '/sign_in_failed'
		end
	end
end

post '/sign_up' do
	@title = 'success'
	@user = User.where(username: params[:username]).first
	if @user.nil?
			@user = User.create(username: params[:username], password: params[:password])
			# @profile = Profile.create(email: params[:email], user_id: @user.id)
			flash[:notice] = 'Congratulations!'
			session[:session_user_id] = @user.id
			session[:session_username] = @user.username
			redirect '/success'
	else
		flash[:alert] = 'The username: #{params[:username] has been taken'
		redirect '/sign_up_failed'
	end
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
	erb :login_success
end

post '/success' do
  erb :success 
end



get '/edit_profile' do
	erb :edit_profile
end

post '/edit_profile' do
	@title = 'Edit Your Profile'
    @user
	Profile.create(fname: params[:name], city: params[:city], birthday: params[:birthday], lname: params[:lname], user_id: "#{@User.id}")
	erb :edit_profile
end


post '/profile' do
	@title = 'Your Profile'
	erb :profile
end

get '/profile' do
	erb :profile
end


