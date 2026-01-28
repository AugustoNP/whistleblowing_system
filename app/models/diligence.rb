class Diligence < ApplicationRecord
  # 1. Associations
  has_many :socios, dependent: :destroy
  has_many :empresa_vinculadas, dependent: :destroy
  has_many :participacao_socios, dependent: :destroy
  has_many :peps, dependent: :destroy
  has_many :parentescos, dependent: :destroy
  has_many :licencas, dependent: :destroy
  has_many :terceiros, dependent: :destroy

  # 2. THE FIX: Enable nested attributes for all child tables
  accepts_nested_attributes_for :socios, :empresa_vinculadas, :participacao_socios, 
                                :peps, :parentescos, :licencas, :terceiros, 
                                allow_destroy: true, reject_if: :all_blank

  # 3. Security/Encryption (If you are using it)
  # encrypts :razao_social, :cnpj, :r_email
  
  enum :status, { pendente: 0, em_analise: 1, resolvido: 2 }, default: :pendente
end