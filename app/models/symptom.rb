class Symptom < ActiveRecord::Base 
    has_many :entries_symptoms
    has_many :entries, through: :entries_symptoms
    has_many :users, through: :entries

    def self.name_array 
        self.all.collect { |symptom| symptom.name.downcase }
    end 
end 