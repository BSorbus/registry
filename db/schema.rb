# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_04_150526) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.uuid "record_id", null: false
    t.uuid "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "idx_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "addresses", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "addressable_type"
    t.uuid "addressable_id"
    t.uuid "address_type_id"
    t.string "country_code", default: "PL"
    t.string "address_combine_id", default: ""
    t.string "province_code", default: ""
    t.string "province_name", default: ""
    t.string "district_code", default: ""
    t.string "district_name", default: ""
    t.string "commune_code", default: ""
    t.string "commune_name", default: ""
    t.string "city_code", default: ""
    t.string "city_name", default: ""
    t.string "parent_city_code", default: ""
    t.string "parent_city_name", default: ""
    t.string "street_code", default: ""
    t.string "street_name", default: ""
    t.string "street_attribute", default: ""
    t.string "address_house", default: ""
    t.string "address_number", default: ""
    t.string "address_postal_code", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["address_postal_code"], name: "index_addresses_on_address_postal_code"
    t.index ["address_type_id"], name: "index_addresses_on_address_type_id"
    t.index ["addressable_type", "addressable_id", "address_type_id"], name: "idx_addresses_addressable_type_id_address_type_uniqueness", unique: true
    t.index ["addressable_type", "addressable_id"], name: "index_addresses_on_addressable_type_and_addressable_id"
    t.index ["city_name"], name: "index_addresses_on_city_name"
    t.index ["commune_name"], name: "index_addresses_on_commune_name"
    t.index ["district_name"], name: "index_addresses_on_district_name"
    t.index ["province_name"], name: "index_addresses_on_province_name"
    t.index ["street_name"], name: "index_addresses_on_street_name"
  end

  create_table "api_keys", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "password"
    t.string "access_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_api_keys_on_name", unique: true
  end

  create_table "approvals", force: :cascade do |t|
    t.uuid "role_id"
    t.uuid "user_id"
    t.uuid "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_approvals_on_author_id"
    t.index ["role_id", "user_id"], name: "index_approvals_on_role_id_and_user_id", unique: true
    t.index ["role_id"], name: "index_approvals_on_role_id"
    t.index ["user_id"], name: "index_approvals_on_user_id"
  end

  create_table "cbo_organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "tax_no"
    t.uuid "cbo_organizationid"
    t.uuid "organization_id"
    t.string "identifier"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cbo_organizationid"], name: "index_cbo_organizations_on_cbo_organizationid"
    t.index ["identifier"], name: "index_cbo_organizations_on_identifier"
    t.index ["name"], name: "index_cbo_organizations_on_name"
    t.index ["organization_id"], name: "index_cbo_organizations_on_organization_id"
    t.index ["tax_no"], name: "index_cbo_organizations_on_tax_no"
  end

  create_table "cbo_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "wso2is_userid"
    t.uuid "cbo_userid"
    t.uuid "user_id"
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "user_name"
    t.boolean "csu_confirmed"
    t.datetime "csu_confirmed_at"
    t.string "csu_confirmed_by"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cbo_userid"], name: "index_cbo_users_on_cbo_userid"
    t.index ["email"], name: "index_cbo_users_on_email", unique: true
    t.index ["first_name"], name: "index_cbo_users_on_first_name"
    t.index ["last_name"], name: "index_cbo_users_on_last_name"
    t.index ["user_id"], name: "index_cbo_users_on_user_id"
    t.index ["wso2is_userid"], name: "index_cbo_users_on_wso2is_userid"
  end

  create_table "feature_types", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "destiny"
    t.string "regexp_format_required"
    t.string "format_example"
    t.date "state_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "destiny"], name: "index_feature_types_on_name_and_destiny", unique: true
  end

  create_table "features", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "featurable_type"
    t.uuid "featurable_id"
    t.uuid "feature_type_id"
    t.string "feature_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["featurable_type", "featurable_id", "feature_type_id"], name: "idx_features_featurable_type_id_feature_type_uniqueness", unique: true
    t.index ["featurable_type", "featurable_id"], name: "index_features_on_featurable_type_and_featurable_id"
    t.index ["feature_type_id"], name: "index_features_on_feature_type_id"
    t.index ["feature_value"], name: "index_features_on_feature_value"
  end

  create_table "organizations", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "author_id"
    t.string "short_name", default: ""
    t.string "name", default: ""
    t.string "nip", default: ""
    t.string "regon", default: ""
    t.uuid "legal_form_type_id"
    t.string "jointly_identifiers", default: ""
    t.text "jointly_addresses", default: ""
    t.string "jointly_addresses_ext", default: ""
    t.uuid "jst_legal_form_type_id"
    t.string "jst_teryt", default: ""
    t.text "note", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_organizations_on_author_id"
    t.index ["jst_legal_form_type_id"], name: "index_organizations_on_jst_legal_form_type_id"
    t.index ["legal_form_type_id"], name: "index_organizations_on_legal_form_type_id"
    t.index ["name"], name: "index_organizations_on_name"
    t.index ["nip"], name: "index_organizations_on_nip"
    t.index ["regon"], name: "index_organizations_on_regon"
    t.index ["short_name"], name: "index_organizations_on_short_name"
  end

  create_table "proposal_areas", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "proposal_id"
    t.string "province_code", default: ""
    t.string "province_name", default: ""
    t.string "district_code", default: ""
    t.string "district_name", default: ""
    t.string "commune_code", default: ""
    t.string "commune_name", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["commune_name"], name: "index_proposal_areas_on_commune_name"
    t.index ["district_name"], name: "index_proposal_areas_on_district_name"
    t.index ["proposal_id", "province_code", "district_code", "commune_code"], name: "idx_proposal_areas_xxx_code_uniqueness", unique: true
    t.index ["proposal_id"], name: "index_proposal_areas_on_proposal_id"
    t.index ["province_name"], name: "index_proposal_areas_on_province_name"
  end

  create_table "proposal_attachments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "proposal_id"
    t.uuid "attachment_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attachment_type_id"], name: "index_proposal_attachments_on_attachment_type_id"
    t.index ["proposal_id"], name: "index_proposal_attachments_on_proposal_id"
  end

  create_table "proposal_networks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "proposal_id"
    t.uuid "network_type_id"
    t.text "description", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["network_type_id"], name: "index_proposal_networks_on_network_type_id"
    t.index ["proposal_id", "network_type_id"], name: "idx_proposal_networks_proposal_id_network_type_uniqueness", unique: true
    t.index ["proposal_id"], name: "index_proposal_networks_on_proposal_id"
  end

  create_table "proposal_services", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "proposal_id"
    t.uuid "service_type_id"
    t.text "description", default: ""
    t.boolean "only_wholesale", default: false
    t.boolean "only_resale", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["proposal_id", "service_type_id"], name: "idx_proposal_services_proposal_service_type_uniqueness", unique: true
    t.index ["proposal_id"], name: "index_proposal_services_on_proposal_id"
    t.index ["service_type_id"], name: "index_proposal_services_on_service_type_id"
  end

  create_table "proposal_statuses", force: :cascade do |t|
    t.string "name"
    t.date "state_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_proposal_statuses_on_name", unique: true
  end

  create_table "proposal_types", force: :cascade do |t|
    t.string "name"
    t.date "state_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_proposal_types_on_name", unique: true
  end

  create_table "proposals", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "author_id"
    t.string "service_type", limit: 1, default: "", null: false
    t.date "insertion_date"
    t.bigint "proposal_type_id"
    t.bigint "proposal_status_id"
    t.uuid "organization_id"
    t.uuid "register_id"
    t.boolean "activity_area_whole_poland", default: true
    t.date "scheduled_start_date"
    t.date "scheduled_end_date"
    t.integer "esod_category"
    t.boolean "confirm_that_the_data_is_correct", default: false
    t.string "write_status"
    t.text "status_comment", default: ""
    t.text "bank_pdf_blob_path"
    t.text "face_image_blob_path"
    t.text "attached_pdf_file_blob_path"
    t.text "note", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_proposals_on_author_id"
    t.index ["organization_id"], name: "index_proposals_on_organization_id"
    t.index ["proposal_status_id"], name: "index_proposals_on_proposal_status_id"
    t.index ["proposal_type_id"], name: "index_proposals_on_proposal_type_id"
    t.index ["register_id"], name: "index_proposals_on_register_id"
    t.index ["service_type"], name: "index_proposals_on_service_type"
  end

  create_table "register_statuses", force: :cascade do |t|
    t.string "name"
    t.date "state_on"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_register_statuses_on_name", unique: true
  end

  create_table "registers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "author_id"
    t.string "service_type", limit: 1, default: "", null: false
    t.bigint "register_status_id"
    t.uuid "organization_id"
    t.integer "register_no"
    t.uuid "proposal_registration_approved_id"
    t.uuid "proposal_current_approved_id"
    t.uuid "proposal_deletion_approved_id"
    t.text "note", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_registers_on_author_id"
    t.index ["organization_id"], name: "index_registers_on_organization_id"
    t.index ["register_no"], name: "index_registers_on_register_no"
    t.index ["register_status_id"], name: "index_registers_on_register_status_id"
    t.index ["service_type"], name: "index_registers_on_service_type"
  end

  create_table "representatives", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "organization_id"
    t.uuid "representative_type_id"
    t.string "first_name", default: ""
    t.string "last_name", default: ""
    t.text "note", default: ""
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_representatives_on_organization_id"
    t.index ["representative_type_id"], name: "index_representatives_on_representative_type_id"
  end

  create_table "roles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "activities", default: [], array: true
    t.text "note", default: ""
    t.uuid "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_roles_on_author_id"
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "wso2is_userid"
    t.string "email", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "user_name"
    t.boolean "csu_confirmed"
    t.datetime "csu_confirmed_at"
    t.string "csu_confirmed_by"
    t.string "session_index"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.text "note", default: ""
    t.uuid "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_users_on_author_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["first_name"], name: "index_users_on_first_name"
    t.index ["last_name"], name: "index_users_on_last_name"
    t.index ["session_index"], name: "index_users_on_session_index"
    t.index ["wso2is_userid"], name: "index_users_on_wso2is_userid"
  end

  create_table "version_associations", force: :cascade do |t|
    t.bigint "version_id"
    t.string "foreign_key_name", null: false
    t.uuid "foreign_key_id"
    t.string "foreign_type"
    t.index ["foreign_key_name", "foreign_key_id", "foreign_type"], name: "index_version_associations_on_foreign_key"
    t.index ["version_id"], name: "index_version_associations_on_version_id"
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.uuid "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.jsonb "object"
    t.jsonb "object_changes"
    t.string "item_subtype"
    t.uuid "author_id"
    t.string "url"
    t.bigint "transaction_id"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
    t.index ["transaction_id"], name: "index_versions_on_transaction_id"
  end

  create_table "works", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "trackable_type"
    t.uuid "trackable_id"
    t.uuid "author_id"
    t.string "action"
    t.string "url"
    t.text "parameters"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_works_on_author_id"
    t.index ["trackable_type", "trackable_id"], name: "index_works_on_trackable_type_and_trackable_id"
  end

  add_foreign_key "addresses", "feature_types", column: "address_type_id"
  add_foreign_key "approvals", "roles"
  add_foreign_key "approvals", "users"
  add_foreign_key "approvals", "users", column: "author_id"
  add_foreign_key "features", "feature_types"
  add_foreign_key "organizations", "feature_types", column: "jst_legal_form_type_id"
  add_foreign_key "organizations", "feature_types", column: "legal_form_type_id"
  add_foreign_key "organizations", "users", column: "author_id"
  add_foreign_key "proposal_areas", "proposals"
  add_foreign_key "proposal_attachments", "feature_types", column: "attachment_type_id"
  add_foreign_key "proposal_attachments", "proposals"
  add_foreign_key "proposal_networks", "feature_types", column: "network_type_id"
  add_foreign_key "proposal_networks", "proposals"
  add_foreign_key "proposal_services", "feature_types", column: "service_type_id"
  add_foreign_key "proposal_services", "proposals"
  add_foreign_key "proposals", "organizations"
  add_foreign_key "proposals", "proposal_statuses"
  add_foreign_key "proposals", "proposal_types"
  add_foreign_key "proposals", "users", column: "author_id"
  add_foreign_key "registers", "organizations"
  add_foreign_key "registers", "register_statuses"
  add_foreign_key "registers", "users", column: "author_id"
  add_foreign_key "representatives", "feature_types", column: "representative_type_id"
  add_foreign_key "representatives", "organizations"
  add_foreign_key "roles", "users", column: "author_id"
  add_foreign_key "works", "users", column: "author_id"
end
