class CreateMartaPrzedsiebiorcaTables < ActiveRecord::Migration[5.2]
  def change
    create_table :marta_przedsiebiorca_tables do |t|
      t.bigint :oryginal_id
      t.string :nazwa
      t.boolean :osoba_fizyczna
      t.string :imie
      t.string :nazwisko
      t.string :nip
      t.string :pesel
      t.string :regon
      t.string :customerkrs

    end
  end
end