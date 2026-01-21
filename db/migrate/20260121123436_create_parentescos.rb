class CreateParentescos < ActiveRecord::Migration[8.1]
  def change
    create_table :parentescos do |t|
      t.references :report, null: false, foreign_key: true
      t.string :integrante
      t.string :agente
      t.string :orgao

      t.timestamps
    end
  end
end
