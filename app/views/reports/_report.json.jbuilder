json.extract! report, :id, :modo, :nome, :email, :categoria, :local, :descricao, :protocolo, :created_at, :updated_at
json.url report_url(report, format: :json)
