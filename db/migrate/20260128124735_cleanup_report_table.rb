class CleanupReportTable < ActiveRecord::Migration[8.1]
  def change
    remove_columns :reports, :razao_social, :cnpj, :nome_fantasia, :website, :endereco, :data_const, :porte, :n_func, :objeto, :paises, :r_nome, :r_email, :r_cargo, :ubo, :ubo_txt, :i_pub, :i_pub_txt, :pep, :par, :rel_emp, :rel_emp_txt, :i_inst, :oc, :inv, :inv_txt, :imp, :imp_txt, :fal, :fal_txt, :restr, :restr_txt, :conf_int
  end
end