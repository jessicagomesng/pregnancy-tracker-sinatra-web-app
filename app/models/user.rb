class User < ActiveRecord::Base 
    has_secure_password 
    
    has_many :entries
    has_many :symptoms, through: :entries
    has_many :messages

end 
