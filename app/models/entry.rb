class Entry < ActiveRecord::Base 
    belongs_to :user
    has_many :entries_symptoms
    has_many :symptoms, through: :entries_symptoms
end 