class AddColumnToMessages < ActiveRecord::Migration[5.2]
    def change 
        add_column :messages, :date_posted, :date
    end 
end 