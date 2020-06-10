class Symptom < ActiveRecord::Base 
    has_many :entries_symptoms
    has_many :entries, through: :entries_symptoms
    has_many :users, through: :entries
end 