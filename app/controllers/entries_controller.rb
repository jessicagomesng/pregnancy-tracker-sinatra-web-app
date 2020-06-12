class EntriesController < ApplicationController 
    get '/entries' do 
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
        binding.pry 

    end 
end 