require 'spec_helper'

describe UsersController do 
    
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

        it 'does not let a user sign up under an existing username' do 
            user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

            visit '/signup'
            fill_in(:username, :with => "hotdoggy")
            fill_in(:password, :with => "ImaPup45")
            fill_in(:email, :with => "Thisshouldntwork@gmail.com")
            click_button 'Sign Up'

            expect(page.current_path).to include('/signup')
            expect(page).to have_content("Sorry, that username and/or email already exists in our system. Please try again.")
        end 

        it 'does not let a user sign up under an existing email' do
            user = User.create(:username => "hotdoggy", :email => "sausagedogs@hotmail.com", :password => "ImaPup45")

            visit '/signup'
            fill_in(:username, :with => "MeNoWorky")
            fill_in(:password, :with => "ImaPup45")
            fill_in(:email, :with => "sausagedogs@hotmail.com")
            click_button 'Sign Up'

            expect(page.current_path).to include('/signup')
            expect(page).to have_content("Sorry, that username and/or email already exists in our system. Please try again.") 
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
end 