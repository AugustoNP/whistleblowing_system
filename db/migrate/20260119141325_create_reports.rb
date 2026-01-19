class CreateReports < ActiveRecord::Migration[8.1]
  def change
    create_table :reports do |t|
      t.string :modo
      t.string :nome
      t.string :email
      t.string :categoria
      t.string :local
      t.text :descricao
      t.string :protocolo

      t.timestamps
    end
  end
end
