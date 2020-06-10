class CreateEntriesSymptoms < ActiveRecord::Migration[5.2] 
    def change
        create_table :entries_symptoms do |t|
            t.integer :symptom_id 
            t.integer :entry_id 
        end 
    end 
end 