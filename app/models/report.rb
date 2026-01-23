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

  # 3. Nested Attributes
  accepts_nested_attributes_for :socios, :empresa_vinculadas, :participacao_socios, 
                                :peps, :parentescos, :licencas, :terceiros, 
                                allow_destroy: true, reject_if: :all_blank

  # 4. Serialization
  serialize :oc, type: Array, coder: JSON
  serialize :i_inst, type: Array, coder: JSON

  # 5. Validations 
  validates :protocolo, uniqueness: true
  validates :status, inclusion: { in: statuses.keys }
  validate :prevent_mixed_report_types

  # 6. Callbacks
  before_validation :generate_protocol, on: :create

  private

  def generate_protocol
    return if protocolo.present?

    self.protocolo = "CD-#{SecureRandom.hex(2).upcase}-#{SecureRandom.hex(2).upcase}"
  end

  def prevent_mixed_report_types
    if razao_social.blank? && cnpj.present?
      errors.add(:cnpj, "não pode ser preenchido em relatos anônimos.")
    end
  end
end