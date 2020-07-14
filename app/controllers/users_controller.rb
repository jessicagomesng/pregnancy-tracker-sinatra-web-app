require 'rack-flash'

class UsersController < ApplicationController 
    use Rack::Flash, :sweep => true

    get '/signup' do 
        if logged_in?
            redirect "/account"
        else 
            erb :'/users/signup'
        end 
    end 

    post '/signup' do
        if params[:email] == "" || params[:password] == "" || params[:username] == ""
            flash[:error] = "You must include a username, email, and password." 
            redirect '/signup'
        else 
            if User.all_usernames.include?(params[:username]) || User.all_emails.include?(params[:email])
                flash[:error] = "Sorry, that username and/or email already exists in our system. Please try again." 
                redirect '/signup'
            else 
                @user = User.create(:username => params[:username], :password => params[:password], :email => params[:email])
                session[:user_id] = @user.id  
                flash[:success] = "User created." 
                redirect "/account"
            end 
        end  
    end 

    get '/login' do 
        if logged_in?
            redirect "/account"
        else 
            erb :'/users/login'
        end 
    end 

    post '/login' do  
        @user = User.find_by(:username => params[:username])

        if @user && @user.authenticate(params[:password])
            session[:user_id] = @user.id 
            redirect "/account"
        else 
            flash[:error] = "Something went wrong. Please try again." 
            redirect '/login'
        end 
    end 

    get '/account' do 
        if logged_in?
            erb :'/users/account'
        else 
            flash[:notice] = "You must be logged in to do that!"
            redirect '/'
        end 
    end 

    get '/logout' do 
        if logged_in? 
            session.clear 
            redirect '/login'
        else 
            flash[:notice] = "You must be logged in to do that!"
            redirect '/'
        end 
    end 
end 