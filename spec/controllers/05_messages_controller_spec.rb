require 'spec_helper'

describe MessagesController do 

    describe "Message Index" do 
        context "logged in" do 
            it 'lets a user view the message index' do 
                user1 = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                message1 = Message.create(:date_posted => 2020-20-06, :content => "Hi! This is my first message!", :user_id => user1.id)
                
                user2 = User.create(:username => "lovemyweasel", :email => "scraphoundsunite@gmail.com", :password => "PeetboBeet123")
                message2 = Message.create(:date_posted => 2020-19-06, :content => "I'm feeling soooo tired today", :user_id => user2.id)
    
                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/messages"
                expect(page.body).to include(message1.content)
                expect(page.body).to include(message2.content)
            end 
        end 

        context "logged out" do 
            it 'does not let a logged out user view the message index' do 
                visit '/messages' 
                expect(page.current_path).to include('/login')
                expect(page).to have_content("You must be logged in to do that!")
            end 
        end
    end 

    describe "Create Message" do 
        context "logged in" do 
            it 'lets user view new message form' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
            
                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit "/messages/new"
                expect(page.status_code).to eq(200)
                expect(page.body).to include("Write a New Message Here:")
            end 

            it 'lets user create new message' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit '/messages/new'
                fill_in(:content, :with => "I am so pregnant! Ready to pop!")
                click_button "Post New Message"

                message = Message.find_by(:content => "I am so pregnant! Ready to pop!")
                expect(message).to be_instance_of(Message)
                expect(message.user_id).to eq(user.id)
                expect(page.status_code).to eq(200)
                expect(page).to have_content("Message created.")
            end

            it 'does not allow a user to create a blank message' do
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit '/messages/new'
                click_button "Post New Message"

                expect(user.messages.length).to eq(0)
                expect(page.current_path).to eq("/messages/new")
                expect(page).to have_content("The content field cannot be left blank.")
            end

            it 'sets the date posted automatically' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit '/messages/new'
                fill_in(:content, :with => "I am so pregnant! Ready to pop!")
                click_button "Post New Message"

                message = Message.find_by(:content => "I am so pregnant! Ready to pop!")
                expect(message.date_posted).to eq(Date.today) 
            end 
        end 

        context "logged out" do 
            it 'does not let a logged out user view the new message form' do 
                visit '/messages/new'
                expect(page.current_path).to include('/login')
                expect(page).to have_content("You must be logged in to do that!")
            end 
        end 
    end 

    describe "Show Message" do
        context "logged in" do
            it 'lets a user view an existing message' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                message = Message.create(:date_posted => 2020-20-06, :content => "Hi! This is my first message!")
                user.messages << message 

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit "/messages/#{message.id}"
                expect(page.status_code).to eq(200)
                expect(page.body).to include(message.content)
            end 

            it 'does not let a user view a message that does not exist' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                
                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit '/messages/5'
                expect(page.current_path).to eq("/messages")
                expect(page).to have_content("Something went wrong. Please try again.")
            end 

            it 'displays edit and delete links if the message belongs to the user' do 
                user = User.create(:username => 'hotdoggy', :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                message = Message.create(:date_posted => 2020-20-06, :content => "HI! This is my first message!")
                user.messages << message 

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/messages/#{message.id}"
                expect(page).to have_link("Edit or Delete")
            end 

            it 'does not display edit and delete links if the message does not belong to that user' do 
                user1 = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                message1 = Message.create(:date_posted => 2020-20-06, :content => "Hi! This is my first message!")
                user1.messages << message1
                
                user2 = User.create(:username => "lovemyweasel", :email => "scraphoundsunite@gmail.com", :password => "PeetboBeet123")
                message2 = Message.create(:date_posted => 2020-19-06, :content => "I'm feeling soooo tired today")
                user2.messages << message2
    
                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/messages/#{message2.id}"
                expect(page).to_not have_link("Edit or Delete")
            end 
        end 
        
        context "logged out" do 
            it "does not let a logged out user view a message" do 
                visit '/messages/1' 
                expect(page).to have_content("You must be logged in to do that!")
                expect(page.current_path).to eq("/login")
            end
        end 
    end 

    describe "Edit Message" do 
        context "logged in" do 
            it 'lets a user view edit form for their own messages' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                message = Message.create(:date_posted => 2020-20-06, :content => "Hi! This is my first message!")
                user.messages << message 

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit "/messages/#{message.id}/edit"
                expect(page.status_code).to eq(200)
                expect(page.body).to include(message.content)
            end 

            it 'contains a link to delete message' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                message = Message.create(:date_posted => 2020-20-06, :content => "Hi! This is my first message!")
                user.messages << message 

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit "/messages/#{message.id}/edit"
                expect(page.status_code).to eq(200)
                expect(page).to have_selector(:link_or_button, 'Delete Message')
            end 

            it 'updates an existing message' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                message = Message.create(:date_posted => 2020-20-06, :content => "Hi! This is my first message!")
                user.messages << message 

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/messages/#{message.id}/edit"

                fill_in(:content, :with => "I have successfully edited this message")
                click_button "Edit Message"

                expect(Message.find_by(:content =>"I have successfully edited this message")).to be_instance_of(Message)
                expect(page.status_code).to eq(200)
                expect(page).to have_content("Message updated.")
            end  

            it 'does not let a user edit a message with blank content' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                message = Message.create(:date_posted => 2020-20-06, :content => "Hi! This is my first message!")
                user.messages << message 
                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/messages/#{message.id}/edit"
                fill_in(:content, :with => "")
                click_button "Edit Message"
                
                expect(Message.find_by(:content => "Hi! This is my first message!")).to be_instance_of(Message)
                expect(page.current_path).to eq("/messages/#{message.id}/edit")
                expect(page).to have_content("The content field cannot be left blank.")
            end 

            it 'does not let a user edit a message that does not belong to him/her' do 
                user1 = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                message1 = Message.create(:date_posted => 2020-20-06, :content => "Hi! This is my first message!")
                user1.messages << message1

                user2 = User.create(:username => "lovemyweasel", :email => "scraphoundsunite@gmail.com", :password => "PeetboBeet123")
                message2 = Message.create(:date_posted => 2020-19-06, :content => "I'm feeling soooo tired today")
                user2.messages << message2

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit "/messages/#{message2.id}/edit"

                expect(page.current_path). to eq("/messages")
                expect(page).to have_content("Sorry, you do not have permissions to edit that message.")
            end 

        end 
      
        context "logged out" do 
            it 'does not let a logged out user edit a message' do 
                message = Message.create(:date_posted => 2020-19-06, :content => "Hey there")
                
                visit "messages/#{message.id}/edit"
                expect(page).to have_content("You must be logged in to do that!")
                expect(page.current_path).to eq('/login')
            end
        end     
    end 

    describe "Delete Message" do
        context "logged in" do 
            it 'lets a user delete own message if logged in' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                message = Message.create(:date_posted => 2020-20-06, :content => "Hi! This is my first message!")
                user.messages << message 

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/messages/#{message.id}/edit"

                click_button("Delete Message")

                expect(Message.find_by(:content =>"Hi! This is my first message!")).to be(nil)
                expect(page.current_path).to eq('/messages')
                expect(page).to have_content("Message deleted.")
            end 
            
        end 
        
        context "logged out" do 
            it 'does not let a logged out user delete a message' do
                message = Message.create(:date_posted => 2020-19-06, :content => "Hey there")
                
                delete "/messages/#{message.id}"
                expect(Message.find_by(:content => "Hey there")).to be_instance_of(Message)
                expect(last_response.location).to include('/login')
            end 
        end 
    end 

end 