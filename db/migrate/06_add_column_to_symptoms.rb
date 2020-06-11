class AddColumnToSymptoms < ActiveRecord::Migration[5.2] 
    def change 
        add_column :symptoms, :date, :date
    end 
end 