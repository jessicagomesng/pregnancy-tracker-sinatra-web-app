class EntriesController < ApplicationController 
    get '/entries' do 
        if logged_in? 
            @user = User.find_by_id(session[:user_id])
            @entries = @user.entries

            erb :'/entries/index'
        else 
            redirect '/login'
        end 
    end 

    get '/entries/new' do 
        if logged_in? 
            @symptoms = Symptom.all 
            erb :'/entries/new'
            #does not let user write an entry without a date, # of weeks, and at least one symptom 
        else 
            redirect '/login'
            #flash message -- you must be logged in to do that 
        end
    end 

    post '/entries' do 
        @user = User.find_by_id(session[:user_id])

        if params[:entry][:date] == "" || params[:entry][:weeks] == ""
            redirect '/entries/new'
            #flash message - these fields cannot be left lbank
        else 
            @entry = Entry.new

            params["entry"].each do |key, value|
                if !value.nil?
                    if key == "symptom_ids"
                        value.each do |symptom_id|
                            symptom = Symptom.find_by_id(symptom_id)
                            @entry.symptoms << symptom
                        end 
                    else 
                        @entry[key] = value 
                    end 
                end 
            end 

            @entry.save 
            @user.entries << @entry 
            
            redirect "/entries/#{@entry.date_slug}"
        end 
    end 

    get '/entries/:slug' do 
        if logged_in? 
            @user = User.find_by_id(session[:user_id])
            @entry = @user.entries.find_by_date_slug(params[:slug])

            erb :'/entries/show'
        else 
            redirect '/login'
        end 
    end 

    #edit 
    #delete
    #list of entries
end 