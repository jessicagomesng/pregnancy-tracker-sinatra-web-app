require 'rack-flash'

class MessagesController < ApplicationController 
    use Rack::Flash, :sweep => true

    get '/messages' do 
        if logged_in? 
            @messages = Message.all 
            erb :'messages/index'
        else
            flash[:notice] = "You must be logged in to do that!"
            redirect '/login'
        end 
    end 
    
    get '/messages/new' do 
        if logged_in? 
            erb :'/messages/new'
        else 
            flash[:notice] = "You must be logged in to do that!"
            redirect '/login'
        end 
    end 

    post '/messages' do 
        if params[:content] != ""
            message = Message.create(:content => params[:content], :date_posted => Date.today) 
            current_user.messages << message 

            flash[:success] = "Message created."
            redirect '/messages'
        else 
            flash[:notice] = "The content field cannot be left blank."
            redirect '/messages/new' 
        end 
    end 

    #edit message
    get '/messages/:id' do 
        @message = Message.find_by_id(params[:id])

        if logged_in? 
            if @message
                erb :'/messages/show'
            else 
                flash[:error] = "Something went wrong. Please try again." 
                redirect '/messages'
            end 
        else 
            flash[:notice] = "You must be logged in to do that!"
            redirect '/login'
        end 
    end 

    get '/messages/:id/edit' do 
        @message = Message.find_by_id(params[:id])

        if logged_in? 
            if @message && @message.user == current_user
                erb :'/messages/edit'
            else 
                flash[:error] = "Sorry, you do not have permissions to edit that message."
                redirect '/messages'
            end 
        else 
            flash[:notice] = "You must be logged in to do that!"
            redirect '/login'
        end 
    end 

    patch '/messages/:id' do 
        @message = Message.find_by_id(params[:id])

        if params["content"] == "" 
            flash[:notice] = "The content field cannot be left blank. To delete message, please press delete."
            redirect "/messages/#{@message.id}/edit"
        else 
            @message.update(:content => params["content"])

            flash[:success] = "Message updated."
            redirect "/messages/#{@message.id}"
        end 
    end 

    #delete message
    delete '/messages/:id' do 
        @message = Message.find_by_id(params[:id])

        if logged_in? && @message.user == current_user 
            @message.delete
            flash[:success] - "Message deleted."
            redirect '/messages'
        else
            redirect '/login'
        end 
    end 

end 