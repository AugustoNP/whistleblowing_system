class AddCheckboxFieldsToReports < ActiveRecord::Migration[8.1]
  def change
    add_column :reports, :oc, :text
    add_column :reports, :i_inst, :text
    add_column :reports, :ubo, :string
  end
end
