class MessagesController < ApplicationController 

    get '/messages' do 
        if logged_in? 
            @messages = Message.all 
            erb :'messages/index'
        else
            redirect '/login'
        end 
    end 
    
    get '/messages/new' do 
        if logged_in? 
            erb :'/messages/new'
        else 
            redirect '/login'
        end 
    end 

    post '/messages' do 
        if params[:content] != ""
            message = Message.create(:content => params[:content], :date_posted => Date.today) 
            current_user.messages << message 

            redirect '/messages'
        else 
            redirect '/messages/new' 
            #flash message - this field cannot be left blank
        end 
    end 

    #edit message
    get '/messages/:id' do 
        @message = Message.find_by_id(params[:id])

        if logged_in? && @message
            erb :'/messages/show'
        else 
            redirect '/login'
        end 
    end 

    get '/messages/:id/edit' do 
        @message = Message.find_by_id(params[:id])

        if logged_in? && @message && @message.user == current_user
            erb :'/messages/edit'
        else 
            redirect '/login'
        end 
    end 

    patch '/messages/:id' do 
        @message = Message.find_by_id(params[:id])

        if params["content"] == "" 
            redirect "/messages/#{@message.id}/edit"
            #flash message - this field cannot be left blank 
        else 
            @message.update(:content => params["content"])
            redirect "/messages/#{@message.id}"
        end 
    end 

    #delete message
    delete '/messages/:id' do 
        @message = Message.find_by_id(params[:id])

        if logged_in? && @message.user == current_user 
            @message.delete
            redirect '/messages'
            #flash message - Message deleted.
        else
            redirect '/login'
        end 
    end 

end 