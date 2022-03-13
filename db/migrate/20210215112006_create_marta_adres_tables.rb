class CreateMartaAdresTables < ActiveRecord::Migration[5.2]
  def change
    create_table :marta_adres_tables do |t|
      t.bigint :oryginal_id
      t.bigint :przedsiebiorca_id
      t.string :kraj
      t.string :wojewodztwo
      t.string :powiat
      t.string :gmina
      t.string :miejscowosc
      t.string :ulica
      t.string :numer_domu
      t.string :numer_lokalu
      t.string :poczta
      t.string :kod_pocztowy
      t.string :skrytka_pocztowa
      t.string :informacje_dodatkowe
      t.string :adres_typ

    end
  end
end
