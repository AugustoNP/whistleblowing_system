class CreateLicencas < ActiveRecord::Migration[8.1]
  def change
    create_table :licencas do |t|
      t.references :report, null: false, foreign_key: true
      t.string :tipo
      t.string :orgao
      t.date :validade

      t.timestamps
    end
  end
end
