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
                :username => "ilikechocolate"
                :email => "chocolate@aol.com"
                :password => "EasterEggs123"
            }

            post '/signup', params 
            expect (last_response.location).to include("/account")
        end 

        it 'does not let a user sign up without a username' do 
            params = {
                :username => "",
                :email => "chocolate@aol.com"
                :password => "EasterEggs123"
              }

            post '/signup', params
            expect(last_response.location).to include('/signup')
        end
        

end 