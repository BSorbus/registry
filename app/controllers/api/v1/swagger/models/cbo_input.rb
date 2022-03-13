module Api::V1::Swagger::Models::CboInput
  include Swagger::Blocks

  swagger_schema :CboInput do
    # key :required, %i[cbo]
    # property :cbo do
    #   key :type, :object
    #   key :required, %i[id typ source]

      property :id do
        key :type, :string
        key :format, :uuid
      end

      property :typ do
        key :type, :string
      end

      property :source do
        key :type, :string
      end


    # end
  end
end