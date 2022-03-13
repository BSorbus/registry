class CreateMartaDzialalnoscTables < ActiveRecord::Migration[5.2]
  def change
    create_table :marta_dzialalnosc_tables do |t|
      t.bigint :wniosek_id
      t.integer :obszar_numer
      t.string :nazwa_skr_uslugi_sieci
      t.string :opis
      t.string :kod

    end
  end
end
