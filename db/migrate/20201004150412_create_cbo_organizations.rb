class CreateCboOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :cbo_organizations, id: :uuid do |t|
      t.string :name, index: true
      t.string :tax_no, index: true
      t.uuid :cbo_organizationid, index: true
      t.uuid :organization_id, index: true
      t.string :identifier, index: true

      t.timestamps
    end
  end
end
