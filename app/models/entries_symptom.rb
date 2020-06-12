class EntriesSymptom < ActiveRecord::Base
    belongs_to :entry
    belongs_to :symptom
end 