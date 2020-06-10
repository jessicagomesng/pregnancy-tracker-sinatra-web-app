class CreateEntries < ActiveRecord::Migration[5.2]
    def change  
        create_table :symptoms do |t|
            t.string :name 
            t.integer :scale 
        end 
    end 
end 