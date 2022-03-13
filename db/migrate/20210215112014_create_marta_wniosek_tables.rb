class CreateMartaWniosekTables < ActiveRecord::Migration[5.2]
  def change
    create_table :marta_wniosek_tables do |t|
      t.bigint :oryginal_id
      t.integer :typ_kod
      t.bigint :rejestr_id
      t.bigint :przedsiebiorca_id
      t.boolean :zaakceptowany
      t.date :data_wplywu_wniosku
      t.date :data_wpisu_do_rejestru
      t.string :sygnatura_sprawy
      t.date :data_sporz_zaswiad
      t.string :adnotacje
      t.string :komentarz

    end
  end
end
