require 'spec_helper'

describe ApplicationController do 

    describe "Homepage" do 
        it 'loads the homepage' do 
            get '/' 
            expect(last_response.status).to eq(200)
            expect(last_response.body).to include("Pregnancy Tracker Web App")
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

end 