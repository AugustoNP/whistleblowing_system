class CreateTerceiros < ActiveRecord::Migration[8.1]
  def change
    create_table :terceiros do |t|
      t.references :report, null: false, foreign_key: true
      t.string :razao
      t.string :cnpj
      t.string :atividade

      t.timestamps
    end
  end
end
