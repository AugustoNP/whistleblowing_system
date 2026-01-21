class AddOcTxtToReports < ActiveRecord::Migration[8.1]
  def change
    add_column :reports, :oc_txt, :text
  end
end
