class AddUserToDiligences < ActiveRecord::Migration[8.1]
  def change
    # 1. Add the column allowing NULL temporarily
    add_reference :diligences, :user, foreign_key: true

    # 2. Assign existing records to the first Admin/Internal user
    reversible do |dir|
      dir.up do
        # We use execute to avoid model dependency issues during migration
        # This finds the first user who isn't a 'visitor' or 'outsider'
        legacy_user_id = exec_query("SELECT id FROM users WHERE role IN (2, 3) LIMIT 1").first&.[]("id")
        
        if legacy_user_id
          execute "UPDATE diligences SET user_id = #{legacy_user_id} WHERE user_id IS NULL"
        else
          # Fallback if no admin exists: use the very first user
          execute "UPDATE diligences SET user_id = (SELECT id FROM users LIMIT 1) WHERE user_id IS NULL"
        end
      end
    end

    # 3. Now that data is populated, we can safely enforce NOT NULL
    change_column_null :diligences, :user_id, false
  end
end