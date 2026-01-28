class MoveRemainingFieldsToDiligence < ActiveRecord::Migration[8.0]
  def change
    # 1. ADD COLUMNS TO DILIGENCES (Corporate Integrity Data)
    change_table :diligences, bulk: true do |t|
      t.string  :c_cod
      t.string  :c_cod_url
      t.string  :c_pac
      t.string  :c_pac_url
      t.string  :c_prog
      t.string  :c_prog_url
      t.string  :c_bri
      t.string  :c_bri_url
      t.string  :c_ddt
      t.text    :c_ddt_desc
      t.string  :c_can
      t.text    :c_can_cont
      t.string  :anon_ret
      t.string  :c_trein
      t.string  :c_mon
      t.text    :c_mon_desc
      t.string  :cert_basic
      t.boolean :t_usa
      t.boolean :t_claus
      t.string  :a_nome
      t.string  :a_cargo
      t.date    :a_data
    end

    # 2. REMOVE COLUMNS FROM REPORTS (Whistleblowing Cleanup)
    change_table :reports, bulk: true do |t|
      t.remove :c_cod, type: :string
      t.remove :c_cod_url, type: :string
      t.remove :c_pac, type: :string
      t.remove :c_pac_url, type: :string
      t.remove :c_prog, type: :string
      t.remove :c_prog_url, type: :string
      t.remove :c_bri, type: :string
      t.remove :c_bri_url, type: :string
      t.remove :c_ddt, type: :string
      t.remove :c_ddt_desc, type: :text
      t.remove :c_can, type: :string
      t.remove :c_can_cont, type: :text
      t.remove :anon_ret, type: :string
      t.remove :c_trein, type: :string
      t.remove :c_mon, type: :string
      t.remove :c_mon_desc, type: :text
      t.remove :cert_basic, type: :string
      t.remove :t_usa, type: :boolean
      t.remove :t_claus, type: :boolean
      t.remove :a_nome, type: :string
      t.remove :a_cargo, type: :string
      t.remove :a_data, type: :date
    end
  end
end