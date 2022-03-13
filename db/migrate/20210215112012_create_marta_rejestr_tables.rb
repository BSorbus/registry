class CreateMartaRejestrTables < ActiveRecord::Migration[5.2]
  def change
    create_table :marta_rejestr_tables do |t|
      t.bigint :oryginal_id
      t.integer :numer_rejestru
      t.bigint :przedsiebiorca_id
      t.date :data_wykreslenia
      t.string :powod_wykreslenia
      t.string :wykreslenie_komentarz

    end
  end
end
