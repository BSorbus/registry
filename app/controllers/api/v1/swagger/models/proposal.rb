module Api::V1::Swagger::Models::Proposal
  include Swagger::Blocks

  swagger_schema :JProposal do
    key :type, :object
    key :required, %i[id proposal_type_id insertion_date jst_resolution_date jst_resolution_number jst_providing_networks jst_provision_telecom_services jst_provision_related_services jst_other_telecom_activities activity_area_whole_poland scheduled_start_date scheduled_end_date author_id]

    property :id do
      key :type, :integer
      key :format, :int64
    end

    property :email do
      key :type, :string
    end

    property :created_at do
      key :type, :string
      key :format, 'date-time'
    end

    property :updated_at do
      key :type, :string
      key :format, 'date-time'
    end
  end


  swagger_schema :TProposal do
    key :type, :object
    key :required, %i[id2 email2 created_at2]

    property :id2 do
      key :type, :integer
      key :format, :int64
    end

    property :email2 do
      key :type, :string
    end

    property :created_at2 do
      key :type, :string
      key :format, 'date-time'
    end

  end


end

