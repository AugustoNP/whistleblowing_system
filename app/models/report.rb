class Report < ApplicationRecord
  before_create :generate_protocol

  private

  def generate_protocol
    self.protocolo = "CD-#{SecureRandom.hex(2).upcase}-#{SecureRandom.hex(2).upcase}"
  end
end
