class Report < ApplicationRecord
  
  attr_readonly :modo, :nome, :email, :categoria, :local, :descricao, :protocolo

  enum :status, { pendente: 0, em_analise: 1, resolvido: 2 }, default: :pendente

  # 2. Validations
  # We removed the 'prevent_mixed_report_types' because it referenced missing columns
  validates :protocolo, uniqueness: true
  validates :status, inclusion: { in: statuses.keys }
  validates :categoria, presence: true
  validates :descricao, presence: true

  # 3. Callbacks
  before_validation :generate_protocol, on: :create

  private

  def generate_protocol
    return if protocolo.present?
    # Keeping your specific hex format
    self.protocolo = "CD-#{SecureRandom.hex(2).upcase}-#{SecureRandom.hex(2).upcase}"
  end
end