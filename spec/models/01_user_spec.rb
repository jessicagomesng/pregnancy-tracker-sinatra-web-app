require "spec_helper"

describe "User" do 
    # before do 
    #     @user = User.create(:username => "preggoeggo", :email => "hi@gmail.com", :password => "Mynameis2")
    it 'responds to authenticate method from has_secure_password' do 
        @user = User.create(:username => "testing", :password => "Testing123", :email => "test@gmail.com")
        expect(@user.authenticate("Testing123")).to be_truthy 
    end 
end