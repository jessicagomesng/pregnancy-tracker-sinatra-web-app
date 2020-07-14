require 'rack-flash'

class EntriesController < ApplicationController 
    use Rack::Flash, :sweep => true

    get '/entries' do 
        if logged_in?
            @entries = current_user.entries 

            erb :'/entries/index'
        else 
            flash[:notice] = "You must be logged in to do that!"
            redirect '/login'
        end 
    end 

    get '/entries/new' do 
        if logged_in?
            @symptoms = Symptom.all 
            erb :'/entries/new'
        else 
            flash[:notice] = "You must be logged in to do that!"
            redirect '/login'
        end 
    end 

    post '/entries' do
        if params[:entry][:date] == "" || params[:entry][:weeks] == ""
            flash[:error] = "You must include a date and how many weeks you are!" 
            redirect '/entries/new'
        else 
            @entry = Entry.new 

            if params["new_symptom"] != ""
                if Symptom.name_array.include?(params["new_symptom"].downcase) 
                    flash[:notice] = "Sorry, you cannot add an existing symptom to the database. To add that symptom, simply edit your entry and select the appropriate symptom."
                else 
                    @entry.symptoms << Symptom.create(:name => params["new_symptom"])
                end 
            end 

            params["entry"].each do |key, value|
                if value != ""
                    if key == "symptom_ids"
                        value.each do |symptom_id|
                            @entry.symptoms << Symptom.find_by_id(symptom_id)
                        end 
                    else 
                        @entry[key] = value 
                    end 
                end 
            end 

            @entry.save 
            current_user.entries << @entry 
            
            flash[:success] = "Entry created."
            redirect "/entries/#{@entry.id}"
        end 
    end 

    get '/entries/:id' do 
        @entry = Entry.find_by_id(params[:id])

        if logged_in?
            if @entry && authorized_to_edit?(@entry)
                erb :'/entries/show'
            else 
                flash[:error] = "Sorry, you do not have permissions to do that."
                redirect '/account'
            end 
        else 
            flash[:notice] = "You must be logged in to do that!"
            redirect '/login'
        end 
    end 

    get '/entries/:id/edit' do 
        @symptoms = Symptom.all 
        @entry = Entry.find_by_id(params[:id])

        if logged_in?
            if @entry && authorized_to_edit?(@entry)
                erb :'/entries/edit'
            else 
                flash[:error] = "Sorry, you do not have permissions to do that."
                redirect '/account'
            end 
        else 
            flash[:notice] = "You must be logged in to do that!"
            redirect '/login'
        end 
    end 

    patch '/entries/:id' do 
        @entry = Entry.find_by_id(params[:id])

        if params[:entry][:date] == "" || params[:entry][:weeks] == ""
            flash[:error] = "You must include a date and how many weeks you are!" 
            redirect "/entries/#{@entry.id}/edit"
        else 
            params["entry"].each do |key, value|
                if value != ""
                    if key == "symptom_ids"
                        @entry.symptoms.clear 
                        
                        value.each do |symptom_id|
                            @entry.symptoms << Symptom.find_by_id(symptom_id)
                        end 
                    else 
                        @entry[key] = value 
                    end
                end
            end 

            if params["new_symptom"] != "" 
                if Symptom.name_array.include?(params["new_symptom"].downcase)
                    flash[:notice] = "Sorry, you cannot add an existing symptom to the database. To add that symptom, simply edit your entry and select the appropriate symptom."
                else 
                    @entry.symptoms << Symptom.create(:name => params["new_symptom"])
                end 
            end 
            
            @entry.save 

            flash[:success] = "Entry edited."
            redirect "/entries/#{@entry.id}"
        end 
    end 

    delete '/entries/:id' do 
        @entry = Entry.find_by_id(params[:id])
        
        if logged_in? && authorized_to_edit?(@entry)
            @entry.delete
            flash[:success] = "Entry deleted."
            redirect "/entries"
        else 
            redirect '/login'
        end 
    end 


end 