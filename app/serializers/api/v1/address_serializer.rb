class Api::V1::AddressSerializer < ActiveModel::Serializer

  # t.references :addressable, polymorphic: true, index: true, type: :uuid
  attributes :id, :address_type, :country_code, :address_combine_id, 
    :province_code, :province_name, :district_code, :district_name, 
    :commune_code, :commune_name, :city_code, :city_name, :parent_city_code, :parent_city_name, 
    :street_code, :street_name, :street_attribute, :address_house, :address_number, :address_postal_code

end


