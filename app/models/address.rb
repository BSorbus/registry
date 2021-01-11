class Address < ApplicationRecord

  # relations
  belongs_to :addressable, polymorphic: true
  belongs_to :address_type, class_name: "FeatureType", inverse_of: :address_type_addresses


  has_paper_trail versions: {
    # class_name: 'AddressVersion'
    # scope: -> { order("id desc") }
  }

  # validates
  validates :address_type, presence: true
  validates :country_code, presence: true
  validates :province_name, presence: true,
                    length: { in: 1..50 }, if: -> { country_code == 'PL' }
  validates :district_name, presence: true,
                    length: { in: 1..50 }, if: -> { country_code == 'PL' }
  validates :commune_name, presence: true,
                    length: { in: 1..50 }, if: -> { country_code == 'PL' }
  validates :city_name, presence: true,
                    length: { in: 1..90 }
  validates :address_house, presence: true,
                    length: { in: 1..10 }
  validates :address_postal_code, presence: true,
                    length: { in: 1..15 }


  def country_fullname(locale)
    "(#{country_code}) - #{ISO3166::Country[country_code].translations[locale]}"     
  end

end
