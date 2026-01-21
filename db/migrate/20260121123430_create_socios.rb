class CreateSocios < ActiveRecord::Migration[8.1]
  def change
    create_table :socios do |t|
      t.references :report, null: false, foreign_key: true
      t.string :nome
      t.string :cargo
      t.decimal :percent

      t.timestamps
    end
  end
end
