require "spec_helper"

describe "User" do 
    before do 
        @user = User.create(:username => "preggoeggo", :email => "hi@gmail.com", :password => "Mynameis2")
