class Entry < ActiveRecord::Base 
    belongs_to :user
    has_many :entries_symptoms
    has_many :symptoms, through: :entries_symptoms

    #need to slugify date

    def date_slug
        self.date.to_s
    end 

    def self.find_by_date_slug(date_slug)
        self.all.detect do |entry|
            entry.date_slug == date_slug
        end 
    end
    
end 