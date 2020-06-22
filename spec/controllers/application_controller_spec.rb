require 'spec_helper'

describe ApplicationController do 

    describe "Homepage" do 
        it 'loads the homepage' do 
            get '/' 
            expect(last_response.status).to eq(200)
            expect(last_response.body).to include("Welcome to the Pregnancy Tracker!")
        end 

        it 'does not let a logged in user view the homepage' do 
            user = User.create(:username => "PeetyPie", :email => "cutestdogever@gmail.com", :password => "Imadog123")

            params = { 
                :username => "PeetyPie",
                :password => "Imadog123"
            }

            post '/login', params
            get '/'
            expect(last_response.location).to include("/account")
        end 
    end 

    describe "Sign-Up Page" do 
        it 'loads the signup page' do 
            get '/signup' 
            expect(last_response.status).to eq(200)
        end 

        it 'signup directs user to account homepage' do 
            visit '/signup'
            fill_in(:username, :with => "ilikechocolate")
            fill_in(:password, :with => "EasterEggs123")
            fill_in(:email, :with => "chocolate@aol.com")
            click_button 'Sign Up'

            expect(page.current_path).to eq('/account')
            expect(page).to have_content("User created.")
        end 

        #need pre-existing user condition here

        it 'does not let a user sign up without a username' do 
            params = {
                :username => "",
                :email => "chocolate@aol.com",
                :password => "EasterEggs123"
              }

            post '/signup', params
            expect(last_response.location).to include('/signup')
        end

        it 'does not let a user sign up without a password' do 
            params = {
                :username => "hithere",
                :email => "chocolate@aol.com",
                :password => ""
            }

            post '/signup', params
            expect(last_response.location).to include('/signup')
        end 

        it 'does not let a user sign up without an email' do 
            params = {
                :username => "hithere",
                :email => "",
                :password => "EasterEggs123"
            }

            post '/signup', params 
            expect(last_response.location).to include('/signup')
        end 

        it 'does not let a logged in user view the sign up page' do 
            params = {
                :username => "hithere", 
                :email => "chocolate@aol.com",
                :password => "EasterEggs123"
            }

            post '/signup', params
            get '/signup'
            expect(last_response.location).to include('/account')
        end 
    end 

    describe "login" do 
        it 'loads the login page' do 
            get '/login'
            expect(last_response.status).to eq(200)
        end 

        it 'loads the account homepage after successful login' do 
            user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

            visit '/login'
            fill_in(:username, :with => "hotdoggy")
            fill_in(:password, :with => "ImaPup45")
            click_button 'Log In'

            expect(page.current_path).to eq('/account')
            expect(page.status_code).to eq(200)
        end 

        it 'does not let a logged in user view the login page' do 
            user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

            params = {
                :username => "hotdoggy",
                :password => "ImaPup45"
            }

            post '/login', params 
            get '/login'
            expect(last_response.location).to include('/account')
        end 

        it 'authenticates username/password combination' do 
            user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

            visit '/login'
            fill_in(:username, :with => "hotdoggy")
            fill_in(:password, :with => "fakepassword")
            click_button 'Log In'

            expect(page.current_path).to eq('/login')
            expect(page).to have_content("Something went wrong. Please try again.")
        end 

        it 'does not let a user log in without a username' do 
            user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

            params = {
                :password => "ImaPup45"
            }

            post '/login', params 
            expect(last_response.location).to include('/login')
        end 

        it 'does not let a user log in without a password' do
            user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

            params = {
                :username => "hotdoggy"
            }

            post '/login', params 
            expect(last_response.location).to include('/login')
        end 
    end 

    describe "logout" do 
        it 'lets a user log out if they are already logged in and redirects to the login page' do 
            user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

            visit '/login'
            fill_in(:username, :with => "hotdoggy")
            fill_in(:password, :with => "ImaPup45")
            click_button 'Log In'

            get '/account'
            click_link('Log Out')
            expect(page.current_path).to eq("/login")
        end 

        it 'redirects to the homepage if the user tries to access logout while not logged in' do 
            visit '/logout' 
            expect(page.current_path).to eq("/")
            expect(page).to have_content("You must be logged in to do that!")
        end 
    end 

    describe "Account Page" do
        context 'logged in' do  
            it 'loads the account homepage if logged in' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                
                visit '/login'
                fill_in(:username, :with => "hotdoggy")
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                get '/account'

                expect(page.body).to include("Welcome")
            end 

            it 'shows the current user homepage' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
    
                visit '/login'
                fill_in(:username, :with => "hotdoggy")
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
    
                visit '/account'
                expect(page.body).to include("Welcome to your account, #{user.username}!")
            end 
        end 

        context 'logged out' do 
            it 'will not load the account homepage if a user is not logged in' do 
                visit '/account'
                expect(page).to have_content("You must be logged in to do that!")
                expect(page.current_path).to eq("/")
            end 
        end 

    end 

    describe "Entries" do 
        it "shows a list of only the user's entries if logged in" do 
            user1 = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
            entry1 = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing", :user_id => user1.id)
            
            user2 = User.create(:username => "lovemyweasel", :email => "scraphoundsunite@gmail.com", :password => "PeetboBeet123")
            entry2 = Entry.create(:date => 2020-19-06, :weeks => 3, :notes => "my mom is pregnant! woof!", :user_id => user2.id)

            visit '/login'
            fill_in(:username, :with => "hotdoggy")
            fill_in(:password, :with => "ImaPup45")
            click_button 'Log In'
            visit "/entries"

            expect(page).to have_selector(:css, 'a[href="entries/1"]')
            expect(page).to_not have_selector(:css, 'a[href="entries/2"]')
        end 

        it 'does not entries if not logged in' do 
            get '/entries'
            expect(last_response.location).to include('/login')
        end 
    end 

    describe "Entry Show Page" do
        context 'logged in' do 
            it 'displays a single entry' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit "/entries/#{entry.id}"
                expect(page.status_code).to eq(200)
                expect(page.body).to include(entry.notes)
                expect(page.body).to include("Edit or Delete Entry")
            end 

            it "does not allow user to access anyone else's entries" do 
                user1 = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry1 = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing", :user_id => user1.id)
                
                user2 = User.create(:username => "lovemyweasel", :email => "scraphoundsunite@gmail.com", :password => "PeetboBeet123")
                entry2 = Entry.create(:date => 2020-19-06, :weeks => 3, :notes => "my mom is pregnant! woof!", :user_id => user2.id)
    
                visit '/login'
                fill_in(:username, :with => "hotdoggy")
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry2.id}"

                expect(page.current_path).to eq("/account")
                expect(page).to have_content("Sorry, you do not have permissions to do that.")
            end 
        end 
        
        context 'logged out' do 
            it 'does not display entry' do 
                get '/entries/1'
                expect(last_response.location).to include('/login')
            end 
        end 
    end
    
    describe "New Entry" do 
        context 'logged in' do 
            it 'displays new entry form' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
               
                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit "/entries/new"
                expect(page.status_code).to eq(200)
                expect(page.body).to include("New Entry:")
            end 

            it 'lets a user create a new entry' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit '/entries/new'
                fill_in(:weeks, :with => 4)
                fill_in(:date, :with => 2020-16-04)
                fill_in(:notes, :with => "This is my new entry")
                click_button "Create New Entry"

                entry = Entry.find_by(:notes => "This is my new entry")
                expect(entry).to be_instance_of(Entry)
                expect(entry.user_id).to eq(user.id)
                expect(page.status_code).to eq(200)
            end 

            it 'does not let a user create an entry without a date' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit '/entries/new'
                fill_in(:weeks, :with => 5)
                fill_in(:notes, :with => "This is my new entry")
                click_button "Create New Entry"

                expect(Entry.find_by(:notes =>"This is my new entry")).to be(nil)
                expect(page.current_path).to eq("/entries/new")
            end 

            it 'does not let a user create an entry without weeks' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit '/entries/new'
                fill_in(:date, :with => 2020-16-04)
                fill_in(:notes, :with => "This is my new entry")
                click_button "Create New Entry"

                expect(Entry.find_by(:notes =>"This is my new entry")).to be(nil)
                expect(page.current_path).to eq("/entries/new")
            end 

            it 'does not let a user create a symptom that already exists' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit '/entries/new'
                fill_in(:date, :with => 2020-16-04)
                fill_in(:weeks, :with => 4)
                fill_in(:new_symptom, :with => "Gas")
                fill_in(:notes, :with => "Hi there! I'm pregnant!")
                click_button "Create New Entry"

                entry = Entry.find_by(:notes => "Hi there! I'm pregnant!")
                # expect(Symptom.find_by(: =>"This is my new entry")).to be(nil)
                expect(page.current_path).to eq("/entries/#{entry.id}")
            end 
        end 

        context 'logged out' do
            it 'does not let user view new entry form' do 
                get '/entries/new' 
                expect(last_response.location).to include('/login')
            end 
        end 
    end 

    describe "Edit Entry" do 
        context 'logged in' do 
            it 'loads edit entry form if logged in' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'

                visit "/entries/#{entry.id}/edit"
                expect(page.status_code).to eq(200)
                expect(page.body).to include(entry.notes)
            end 

            it "does not let user edit anyone else's entry" do 
                user1 = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry1 = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing", :user_id => user1.id)
                
                user2 = User.create(:username => "lovemyweasel", :email => "scraphoundsunite@gmail.com", :password => "PeetboBeet123")
                entry2 = Entry.create(:date => 2020-19-06, :weeks => 3, :notes => "my mom is pregnant! woof!", :user_id => user2.id)
    
                visit '/login'
                fill_in(:username, :with => "hotdoggy")
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry2.id}/edit"

                expect(page.current_path).to eq("/account")
                expect(page).to have_content("Sorry, you do not have permissions to do that.")
            end 

            it 'updates an existing entry' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry.id}/edit"

                fill_in(:notes, :with => "successfully edited")
                click_button "Edit Entry"

                expect(Entry.find_by(:notes =>"successfully edited")).to be_instance_of(Entry)
                expect(Entry.find_by(:notes => "testing")).to be(nil)
                expect(page.status_code).to eq(200)
            end 

            it 'does not let a user edit an entry without a date' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry.id}/edit"

                fill_in(:date, with: "")
                fill_in(:notes, with: "successfully edited")
                click_button "Edit Entry"
                
                expect(Entry.find_by(:notes =>"successfully edited")).to be(nil)
                expect(page.current_path).to eq("/entries/#{entry.id}/edit")
            end 

            it 'does not let a user edit an entry without weeks' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry.id}/edit"
                fill_in(:weeks, with: "")
                fill_in(:notes, with: "successfully edited")
                click_button "Edit Entry"
                
                expect(Entry.find_by(:notes =>"successfully edited")).to be(nil)
                expect(page.current_path).to eq("/entries/#{entry.id}/edit")
            end 
        end 

        context 'logged out' do 
            it 'does not allow user to edit entry if not logged in' do 
                get '/entries/1/edit'
                expect(last_response.location).to include('/login')
            end 
        end 
    end 

    describe "Delete Entry" do 
        context "logged in" do 
            it 'lets a user delete own entry' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)

                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry.id}/edit"

                click_button "Delete Entry"

                expect(Entry.find_by(:notes => "testing this bad boy out")).to be(nil)
                expect(page.status_code).to eq(200)
            end 

            it "does not let a user delete another user's entry" do 
                user1 = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry1 = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing", :user_id => user1.id)
                
                user2 = User.create(:username => "lovemyweasel", :email => "scraphoundsunite@gmail.com", :password => "PeetboBeet123")
                entry2 = Entry.create(:date => 2020-19-06, :weeks => 3, :notes => "my mom is pregnant! woof!", :user_id => user2.id)
    
                visit '/login'
                fill_in(:username, :with => "hotdoggy") 
                fill_in(:password, :with => "ImaPup45")
                click_button 'Log In'
                visit "/entries/#{entry2.id}/edit"

                expect(page.current_path).to eq('/account')
            end 
        end 

        context "logged out" do 
            it 'does not let a user delete an entry if logged out' do 
                user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
                entry = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing this bad boy out", :user_id => user.id)
                visit "/entries/#{entry.id}"
                expect(page.current_path).to eq("/login")
            end 
        end 
    end 

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
                get '/messages' 
                expect(last_response.location).to include('/login')
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
                get '/messages/new'
                expect(last_response.location).to include('/login')
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