class CreateEntries < ActiveRecord::Migration[5.2]
    def change  
        create_table :entries do |t|
            t.integer :user_id
            t.date :date
            t.float :temperature 
            t.float :weight
            t.integer :weeks
            t.string :notes 
            t.string :to_dos
        end 
    end 
end 