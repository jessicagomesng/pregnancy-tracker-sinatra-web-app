class RemoveColumnFromSymptoms < ActiveRecord::Migration[5.2]
    def change 
        remove_column :symptoms, :scale 
    end 
end