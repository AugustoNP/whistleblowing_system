# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_01_28_132633) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "diligences", force: :cascade do |t|
    t.string "a_cargo"
    t.date "a_data"
    t.string "a_nome"
    t.string "anon_ret"
    t.string "c_bri"
    t.string "c_bri_url"
    t.string "c_can"
    t.text "c_can_cont"
    t.string "c_cod"
    t.string "c_cod_url"
    t.string "c_ddt"
    t.text "c_ddt_desc"
    t.string "c_mon"
    t.text "c_mon_desc"
    t.string "c_pac"
    t.string "c_pac_url"
    t.string "c_prog"
    t.string "c_prog_url"
    t.string "c_trein"
    t.string "cert_basic"
    t.string "cnpj"
    t.text "conf_int"
    t.datetime "created_at", null: false
    t.date "data_const"
    t.string "endereco"
    t.string "fal"
    t.text "fal_txt"
    t.text "i_inst"
    t.string "i_pub"
    t.text "i_pub_txt"
    t.string "imp"
    t.text "imp_txt"
    t.string "inv"
    t.text "inv_txt"
    t.integer "n_func"
    t.string "nome_fantasia"
    t.text "objeto"
    t.text "oc"
    t.text "oc_txt"
    t.string "paises"
    t.string "par"
    t.string "pep"
    t.string "porte"
    t.string "protocolo"
    t.string "r_cargo"
    t.string "r_email"
    t.string "r_nome"
    t.string "razao_social"
    t.string "rel_emp"
    t.text "rel_emp_txt"
    t.string "restr"
    t.text "restr_txt"
    t.integer "status"
    t.boolean "t_claus"
    t.boolean "t_usa"
    t.string "ubo"
    t.text "ubo_txt"
    t.datetime "updated_at", null: false
    t.string "website"
  end

  create_table "empresa_vinculadas", force: :cascade do |t|
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.bigint "diligence_id", null: false
    t.string "razao"
    t.string "tipo"
    t.datetime "updated_at", null: false
    t.index ["diligence_id"], name: "index_empresa_vinculadas_on_diligence_id"
  end

  create_table "licencas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.bigint "diligence_id", null: false
    t.string "orgao"
    t.string "tipo"
    t.datetime "updated_at", null: false
    t.date "validade"
    t.index ["diligence_id"], name: "index_licencas_on_diligence_id"
  end

  create_table "parentescos", force: :cascade do |t|
    t.string "agente"
    t.datetime "created_at", null: false
    t.bigint "diligence_id", null: false
    t.string "integrante"
    t.string "orgao"
    t.datetime "updated_at", null: false
    t.index ["diligence_id"], name: "index_parentescos_on_diligence_id"
  end

  create_table "participacao_socios", force: :cascade do |t|
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.bigint "diligence_id", null: false
    t.string "empresa"
    t.string "socio"
    t.datetime "updated_at", null: false
    t.index ["diligence_id"], name: "index_participacao_socios_on_diligence_id"
  end

  create_table "peps", force: :cascade do |t|
    t.string "cargo"
    t.datetime "created_at", null: false
    t.bigint "diligence_id", null: false
    t.string "nome"
    t.string "orgao"
    t.datetime "updated_at", null: false
    t.index ["diligence_id"], name: "index_peps_on_diligence_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "categoria"
    t.datetime "created_at", null: false
    t.text "descricao"
    t.string "email"
    t.string "local"
    t.string "modo"
    t.string "nome"
    t.text "oc_txt"
    t.string "protocolo"
    t.integer "status"
    t.datetime "updated_at", null: false
  end

  create_table "sessions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "updated_at", null: false
    t.string "user_agent"
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "socios", force: :cascade do |t|
    t.string "cargo"
    t.datetime "created_at", null: false
    t.bigint "diligence_id", null: false
    t.string "nome"
    t.decimal "percent"
    t.datetime "updated_at", null: false
    t.index ["diligence_id"], name: "index_socios_on_diligence_id"
  end

  create_table "terceiros", force: :cascade do |t|
    t.string "atividade"
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.bigint "diligence_id", null: false
    t.string "razao"
    t.datetime "updated_at", null: false
    t.index ["diligence_id"], name: "index_terceiros_on_diligence_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email_address", null: false
    t.string "password_digest", null: false
    t.integer "role"
    t.datetime "updated_at", null: false
    t.string "username", null: false
    t.index ["email_address"], name: "index_users_on_email_address", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "empresa_vinculadas", "diligences"
  add_foreign_key "licencas", "diligences"
  add_foreign_key "parentescos", "diligences"
  add_foreign_key "participacao_socios", "diligences"
  add_foreign_key "peps", "diligences"
  add_foreign_key "sessions", "users"
  add_foreign_key "socios", "diligences"
  add_foreign_key "terceiros", "diligences"
end
