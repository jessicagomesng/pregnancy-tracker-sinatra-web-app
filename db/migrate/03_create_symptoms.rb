class CreateSymptoms < ActiveRecord::Migration[5.2]
    def change  
        create_table :symptoms do |t|
            t.string :name 
        end 
    end 
end 