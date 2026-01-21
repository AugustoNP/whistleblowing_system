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

ActiveRecord::Schema[8.1].define(version: 2026_01_21_165153) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "empresa_vinculadas", force: :cascade do |t|
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.string "razao"
    t.bigint "report_id", null: false
    t.string "tipo"
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_empresa_vinculadas_on_report_id"
  end

  create_table "licencas", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "orgao"
    t.bigint "report_id", null: false
    t.string "tipo"
    t.datetime "updated_at", null: false
    t.date "validade"
    t.index ["report_id"], name: "index_licencas_on_report_id"
  end

  create_table "parentescos", force: :cascade do |t|
    t.string "agente"
    t.datetime "created_at", null: false
    t.string "integrante"
    t.string "orgao"
    t.bigint "report_id", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_parentescos_on_report_id"
  end

  create_table "participacao_socios", force: :cascade do |t|
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.string "empresa"
    t.bigint "report_id", null: false
    t.string "socio"
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_participacao_socios_on_report_id"
  end

  create_table "peps", force: :cascade do |t|
    t.string "cargo"
    t.datetime "created_at", null: false
    t.string "nome"
    t.string "orgao"
    t.bigint "report_id", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_peps_on_report_id"
  end

  create_table "reports", force: :cascade do |t|
    t.string "a_cargo"
    t.date "a_data"
    t.string "a_nome"
    t.boolean "anon_ret"
    t.string "c_bri"
    t.string "c_bri_url"
    t.string "c_can"
    t.string "c_can_cont"
    t.string "c_cod"
    t.string "c_cod_url"
    t.string "c_ddt"
    t.string "c_ddt_desc"
    t.string "c_mon"
    t.string "c_mon_desc"
    t.string "c_pac"
    t.string "c_pac_url"
    t.string "c_prog"
    t.string "c_prog_url"
    t.string "c_trein"
    t.string "categoria"
    t.text "cert_basic"
    t.string "cnpj"
    t.text "conf_int"
    t.datetime "created_at", null: false
    t.date "data_const"
    t.text "descricao"
    t.string "email"
    t.string "endereco"
    t.text "i_inst"
    t.string "i_pub"
    t.text "i_pub_txt"
    t.string "local"
    t.string "modo"
    t.integer "n_func"
    t.string "nome"
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
    t.string "t_claus"
    t.string "t_usa"
    t.string "ubo"
    t.text "ubo_txt"
    t.datetime "updated_at", null: false
    t.string "website"
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
    t.string "nome"
    t.decimal "percent"
    t.bigint "report_id", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_socios_on_report_id"
  end

  create_table "terceiros", force: :cascade do |t|
    t.string "atividade"
    t.string "cnpj"
    t.datetime "created_at", null: false
    t.string "razao"
    t.bigint "report_id", null: false
    t.datetime "updated_at", null: false
    t.index ["report_id"], name: "index_terceiros_on_report_id"
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

  add_foreign_key "empresa_vinculadas", "reports"
  add_foreign_key "licencas", "reports"
  add_foreign_key "parentescos", "reports"
  add_foreign_key "participacao_socios", "reports"
  add_foreign_key "peps", "reports"
  add_foreign_key "sessions", "users"
  add_foreign_key "socios", "reports"
  add_foreign_key "terceiros", "reports"
end
