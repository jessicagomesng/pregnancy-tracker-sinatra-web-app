class Entry < ActiveRecord::Base 
    belongs_to :user
    has_many :entries_symptom
    has_many :symptoms, through: :entries_symptom
end 