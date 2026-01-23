class AddMissingDiligenceFieldsToReports < ActiveRecord::Migration[8.1]
  def change
    add_column :reports, :inv, :string
    add_column :reports, :inv_txt, :text
    add_column :reports, :imp, :string
    add_column :reports, :imp_txt, :text
    add_column :reports, :fal, :string
    add_column :reports, :fal_txt, :text
  end
end
