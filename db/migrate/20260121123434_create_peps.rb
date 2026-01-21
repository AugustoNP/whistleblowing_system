class CreatePeps < ActiveRecord::Migration[8.1]
  def change
    create_table :peps do |t|
      t.references :report, null: false, foreign_key: true
      t.string :nome
      t.string :orgao
      t.string :cargo

      t.timestamps
    end
  end
end
