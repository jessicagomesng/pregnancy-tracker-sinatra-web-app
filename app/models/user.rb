class User < ActiveRecord::Base 
    has_secure_password 
    
    has_many :entries
    has_many :symptoms, through: :entries
    has_many :messages

    def self.all_usernames
        self.all.collect do |user|
            user.username 
        end 
    end 

    def self.all_emails
        self.all.collect do |user|
            user.email 
        end 
    end

end 
