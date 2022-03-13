class CreateMartaReprezentantTables < ActiveRecord::Migration[5.2]
  def change
    create_table :marta_reprezentant_tables do |t|
      t.bigint :oryginal_id
      t.bigint :przedsiebiorca_id
      t.string :typ_reprezentacji
      t.string :imie
      t.string :nazwisko
      t.string :rola
      t.string :telefon
      t.string :fax
      t.string :email
      t.string :informacja_dodatkowa
      t.bigint :adres_id

    end
  end
end
