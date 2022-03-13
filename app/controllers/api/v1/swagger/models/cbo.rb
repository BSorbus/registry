module Api::V1::Swagger::Models::Cbo
  include Swagger::Blocks

  swagger_schema :Cbo do
    key :type, :object
    key :required, %i[code message]

    property :code do
      key :type, :string
    end

    property :message do
      key :type, :string
    end

    # property :updated_at do
    #   key :type, :string
    #   key :format, 'date-time'
    # end
  end
end
