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
            params = {
                :username => "ilikechocolate",
                :email => "chocolate@aol.com",
                :password => "EasterEggs123"
            }

            post '/signup', params 
            expect(last_response.location).to include("/account")
        end 

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
                :email => "",
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

            params = {
                :username => "hotdoggy",
                :password => "ImaPup45"
            }

            post '/login', params
            expect(last_response.status).to eq(302)
            follow_redirect!
            expect(last_response.status).to eq(200)
            expect(last_response.location).to include('/account')
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

            params = {
                :username => "hotdoggy",
                :password => "fakepassword"
            }

            post '/login', params 
            expect(last_response.location).to include('/login')
        end 

        it 'does not let a user log in without a username' do 
            user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

            params = {
                :password => "ImaPup45"
            }

            post '/login', params 
            expect(last_response.location).to include('/login')
        end 

        it 'does not let a user log in witohut a password' do
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

            params = {
                :username => "hotdoggy",
                :password => "ImaPup45"
            }

            post '/login', params
            get '/logout'
            expect(last_response.status).to eq(302)
            follow_redirect!
            expect(last_response.status).to eq(200)
            expect(last_response.location).to include('/login')
        end 

        it 'redirects to the homepage if the user tries to access logout while not logged in' do 
            get '/logout' 
            expect(last_response.location).to include("/")
        end 
    end 

    describe "Account Page" do 
        it 'loads the account homepage if logged in' do 
            user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
            
            visit '/login'
            fill_in(:username, :with => "hotdoggy")
            fill_in(:password, :with => "ImaPup45")
            click_button 'Log In'
            get '/account'

            expect(page.body).to include("Welcome")
        end 

        it 'will not load the account homepage if a user is not logged in' do 
            get '/account'
            expect(last_response.location).to include('/')
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

    describe "Entries" do 
        it "shows a list of only the user's entries if logged in" do 
            user1 = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")
            entry1 = Entry.create(:date => 2020-14-06, :weeks => 5, :notes => "testing", :user_id => user1.id)
            
            user2 = User.create(:username => "lovemyweasel", :email => "scraphoundsunite@gmail.com", :password => "PeetboBeet123")
            entry1 = Entry.create(:date => 2020-19-06, :weeks => 3, :notes => "my mom is pregnant! woof!", :user_id => user2.id)

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
                entry1 = Entry.create(:date => 2020-19-06, :weeks => 3, :notes => "my mom is pregnant! woof!", :user_id => user2.id)
    
                params = {
                    :username => "hotdoggy",
                    :password => "ImaPup45"
                }

                post "/login", params  
                get "/entries/2"
                expect(last_response.status).to eq(302)
                follow_redirect!
                expect(last_response.location).to include("/account")
            end 
        end 
        
        context 'logged out' do 
            it 'does not display entry if user is not logged in' do 
                get '/entries/1'
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
                entry1 = Entry.create(:date => 2020-19-06, :weeks => 3, :notes => "my mom is pregnant! woof!", :user_id => user2.id)
    
                params = {
                    :username => "hotdoggy",
                    :password => "ImaPup45"
                }

                post "/login", params  
                get "/entries/2/edit"
                expect(last_response.status).to eq(302)
                follow_redirect!
                expect(last_response.location).to include("/account")
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
            end 

            it 'does not let a user edit an entry without a week' do 
            end 
        end 

        context 'logged out' do 
            it 'does not allow user to edit entry if not logged in' do 
                get '/entries/1/edit'
                expect(last_response.location).to include('/login')
            end 
        end 
    end 

end 