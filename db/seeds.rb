puts "Alinhando usuários..."

users_data = [
  { username: 'admin',      email_address: 'adminuser@gmail.com',      password: 'adminuser123', role: :admin },
  { username: 'diligence',  email_address: 'diligenceuser@gmail.com',  password: 'diligenceuser123', role: :diligence },
  { username: 'rh',         email_address: 'rhuser@gmail.com',         password: 'rhuser123', role: :rh }
]

users_data.each do |data|
  user = User.find_or_initialize_by(email_address: data[:email_address])
  user.username = data[:username]
  user.password = data[:password]
  user.role     = data[:role]
  
  if user.save
    puts "Criado: #{user.username} como #{user.role}"
  else
    puts "FALHA em criar #{data[:username]}: #{user.errors.full_messages.join(', ')}"
  end
end

puts "Alinhamento completo."

