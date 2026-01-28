class Diligence < ApplicationRecord

  has_many :socios, dependent: :destroy
  has_many :empresa_vinculadas, dependent: :destroy
  has_many :participacao_socios, dependent: :destroy
  has_many :peps, dependent: :destroy
  has_many :parentescos, dependent: :destroy
  has_many :licencas, dependent: :destroy
  has_many :terceiros, dependent: :destroy


  accepts_nested_attributes_for :socios, :empresa_vinculadas, :participacao_socios, 
                                :peps, :parentescos, :licencas, :terceiros, 
                                allow_destroy: true, reject_if: :all_blank


  enum :status, { pendente: 0, em_analise: 1, resolvido: 2 }, default: :pendente

  # encrypts :r_nome, :r_email, :r_cargo, :oc_txt, :ubo_txt


  before_validation :generate_protocol, on: :create

  before_validation :normalize_cnpj

  validates :razao_social, :cnpj, presence: true
  validates :cnpj, uniqueness: { message: "já está cadastrado" }, cnpj: true

  private

  def normalize_cnpj
    self.cnpj = cnpj.to_s.gsub(/\D/, '') if cnpj.present?
  end


  def generate_protocol
    self.protocolo ||= "DD-#{SecureRandom.hex(4).upcase}"
  end
end