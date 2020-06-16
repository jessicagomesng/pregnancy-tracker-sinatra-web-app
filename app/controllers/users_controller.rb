class UsersController < ApplicationController 
    get '/login' do 
        #contains a link to forgotten password
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
            #raise flash message, sign up link
            redirect '/login'
        end 
    end 

    get '/signup' do 
        if logged_in?
            redirect "/account"
        else 
            erb :'/users/signup'
        end 
    end 

    post '/signup' do
        if params[:email] == "" || params[:password] == "" || params[:username] == ""
            redirect '/signup'
            #flash message about failure 
        else 
            if all_usernames.include?(params[:username]) || all_emails.include?(params[:email])
                redirect '/signup'
                #flash message about failure
            else 
                @user = User.create(:username => params[:username], :password => params[:password], :email => params[:email])
                session[:user_id] = @user.id  
                redirect "/account"
            end 
        end  
    end 

    get '/account' do 
        if logged_in?
            erb :'/users/account'
        else 
            redirect '/'
        end 
    end 

    get '/logout' do 
        if logged_in? 
            session.clear 
            redirect '/login'
            #logout successful flash message
        else 
            redirect '/'
        end 
    end 
end 