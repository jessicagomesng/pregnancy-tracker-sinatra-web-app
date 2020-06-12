class CreateEntriesSymptom < ActiveRecord::Migration[5.2] 
    def change
        create_table :entries_symptom do |t|
            t.integer :symptom_id 
            t.integer :entry_id 
        end 
    end 
end 