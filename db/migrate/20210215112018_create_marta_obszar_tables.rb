class CreateMartaObszarTables < ActiveRecord::Migration[5.2]
  def change
    create_table :marta_obszar_tables do |t|
      t.bigint :wniosek_id
      t.integer :obszar_numer
      t.string :obszar
      t.string :jednostka_nadrzedna
      t.string :opis

    end
  end
end
