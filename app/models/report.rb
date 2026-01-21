class Report < ApplicationRecord
# 1. Statuses
  enum :status, { pendente: 0, em_analise: 1, resolvido: 2 }, default: :pendente

  # 2. Relationships
  has_many :socios, dependent: :destroy
  has_many :empresa_vinculadas, dependent: :destroy
  has_many :participacao_socios, dependent: :destroy
  has_many :peps, dependent: :destroy
  has_many :parentescos, dependent: :destroy
  has_many :licencas, dependent: :destroy
  has_many :terceiros, dependent: :destroy

  # 3. Nested Attributes (Required for the form to save table data)
  accepts_nested_attributes_for :socios, :empresa_vinculadas, :participacao_socios, 
                                :peps, :parentescos, :licencas, :terceiros, 
                                allow_destroy: true, reject_if: :all_blank

  # 4. Array Serialization (Required for Checkboxes)
  # This allows the 'oc' and 'i_inst' params to save as proper arrays
  serialize :oc, type: Array, coder: JSON
  serialize :i_inst, type: Array, coder: JSON

  # 5. Callbacks
  before_create :generate_protocol

  private

  def generate_protocol
    # Consistent with your current CD-XXXX-XXXX format
    self.protocolo = "CD-#{SecureRandom.hex(2).upcase}-#{SecureRandom.hex(2).upcase}"
  end
end