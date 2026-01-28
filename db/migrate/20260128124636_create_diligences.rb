class CreateDiligences < ActiveRecord::Migration[8.1]
  def change
    create_table :diligences do |t|
      t.string :protocolo
      t.integer :status
      t.string :razao_social
      t.string :cnpj
      t.string :nome_fantasia
      t.string :website
      t.string :endereco
      t.date :data_const
      t.string :porte
      t.integer :n_func
      t.text :objeto
      t.string :paises
      t.string :r_nome
      t.string :r_email
      t.string :r_cargo
      t.string :ubo
      t.text :ubo_txt
      t.string :i_pub
      t.text :i_pub_txt
      t.string :pep
      t.string :par
      t.string :rel_emp
      t.text :rel_emp_txt
      t.text :i_inst
      t.text :oc
      t.text :oc_txt
      t.string :inv
      t.text :inv_txt
      t.string :imp
      t.text :imp_txt
      t.string :fal
      t.text :fal_txt
      t.string :restr
      t.text :restr_txt
      t.text :conf_int

      t.timestamps
    end
  end
end
