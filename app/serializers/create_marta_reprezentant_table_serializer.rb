class CreateMartaReprezentantTableSerializer < ActiveModel::Serializer
  attributes :id, :oryginal_id, :przedsiebiorca_id, :typ_reprezentacji, :imie, :nazwisko, :rola, :telefon, :fax, :email, :informacja_dodatkowa, :adres_id
end
