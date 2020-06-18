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
            expect (last_response.status).to eq(200)
        end 

        it 'signup directs user to account homepage' do 
            params = {
                :username => "ilikechocolate",
                :email => "chocolate@aol.com",
                :password => "EasterEggs123"
            }

            post '/signup', params 
            expect (last_response.location).to include("/account")
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
    end 

end 