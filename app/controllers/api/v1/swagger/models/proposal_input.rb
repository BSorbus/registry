module Api::V1::Swagger::Models::ProposalInput
  include Swagger::Blocks

  swagger_schema :JProposalInput do
    key :required, %i[proposal]
    property :proposal do
      key :type, :object
      key :required, %i[proposal_type_id insertion_date jst_resolution_date jst_resolution_number jst_providing_networks jst_provision_telecom_services jst_provision_related_services jst_other_telecom_activities activity_area_whole_poland scheduled_start_date scheduled_end_date author_id]

      property :proposal_type_id do
        key :type, :integer
        key :format, :int32
        key :enum, [1,2,3]
      end

      property :insertion_date do
        key :type, :string
        key :format, :date
      end

      property :organization_id do
        key :type, :string
        key :format, :uuid
      end

      property :register_id do
        key :type, :string
        key :format, :uuid
      end

      property :jst_resolution_date do
        key :type, :string
        key :format, :date
      end

      property :jst_resolution_number do
        key :type, :string
      end

      property :jst_providing_networks do
        key :type, :boolean
        key :nullable, false
      end

      property :jst_provision_telecom_services do
        key :type, :boolean
        key :nullable, false
      end

      property :jst_provision_related_services do
        key :type, :boolean
        key :nullable, false
      end

      property :jst_other_telecom_activities do
        key :type, :boolean
        key :nullable, false
      end

      property :activity_area_whole_poland do
        key :description, 'You must set to "false" if you want to define "proposal_areas_attributes"'
        key :type, :boolean
        key :nullable, false
      end

      property :scheduled_start_date do
        key :type, :string
        key :format, :date
      end

      property :scheduled_end_date do
        key :type, :string
        key :format, :date
      end

      property :author_id do
        key :type, :string
        key :format, :email
      end

      # property :proposal_areas_attributes do
      #   key :type, :array
      #   items do
      #     key :'$ref', :PetInput
      #   end
      # end

      property :proposal_areas_attributes do
        key :description, 'You must set "activity_area_whole_poland" to "false"'
        key :type, :array
        items do
          key :'$ref', :AreaInput
        end
      end

      # property :proposal_areas_attributes do
      #   key :'$ref', :TProposalInput
      # end

    end
  end


  #-------------------------------------------------------------------------------

  swagger_schema :TProposalInput do
    key :required, %i[proposal]
    property :proposal do
      key :type, :object
      key :required, %i[email2 password2]

      property :email2 do
        key :type, :string
      end

      property :password2 do
        key :type, :string
      end
    end
  end


end