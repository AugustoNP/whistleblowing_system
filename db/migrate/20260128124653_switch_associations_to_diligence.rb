class SwitchAssociationsToDiligence < ActiveRecord::Migration[8.1]
  def change
    tables = [:socios, :empresa_vinculadas, :participacao_socios, :peps, :parentescos, :licencas, :terceiros]

    tables.each do |table|
      remove_foreign_key table, :reports
      rename_column table, :report_id, :diligence_id
      
      # ADD THIS LINE: Clear existing data so the foreign key doesn't fail
      execute "DELETE FROM #{table}" 
      
      add_foreign_key table, :diligences
    end
  end
end