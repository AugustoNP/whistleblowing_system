class CreateParticipacaoSocios < ActiveRecord::Migration[8.1]
  def change
    create_table :participacao_socios do |t|
      t.references :report, null: false, foreign_key: true
      t.string :socio
      t.string :empresa
      t.string :cnpj

      t.timestamps
    end
  end
end
