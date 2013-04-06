class AddTimestampToCallQueue < ActiveRecord::Migration
    def change
        change_table(:call_queue) { |t| t.timestamps }
    end
end
