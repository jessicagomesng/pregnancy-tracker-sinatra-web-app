class ApplicationController < Sinatra::Base 
    configure do
        set :public_view, 'public' 
        set :views, 'app/views'
        enable :sessions
        set :session_secret, "pregnancy_tracker_app_hidden_key"
    end 

    get '/' do 
        #add condition so this cannot be accessed if user is logged in
        erb :index
    end 

    helpers do 
        def logged_in?
            !!current_user
        end 

        def current_user 
            @current_user = User.find_by_id(session[:user_id])
        end 

        def all_usernames
            User.all.collect do |user|
                user.username 
            end 
        end 

        def all_emails
            User.all.collect do |user|
                user.email 
            end 
        end
    end 

end 

