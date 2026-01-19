class Report < ApplicationRecord
  # Define the statuses
  enum :status, { pendente: 0, em_analise: 1, resolvido: 2 }, default: :pendente

  before_create :generate_protocol

  private

  def generate_protocol
    self.protocolo = "CD-#{SecureRandom.hex(2).upcase}-#{SecureRandom.hex(2).upcase}"
  end
end