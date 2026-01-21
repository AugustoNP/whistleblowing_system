class CreateEmpresaVinculadas < ActiveRecord::Migration[8.1]
  def change
    create_table :empresa_vinculadas do |t|
      t.references :report, null: false, foreign_key: true
      t.string :razao
      t.string :cnpj
      t.string :tipo

      t.timestamps
    end
  end
end
