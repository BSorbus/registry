module Api::V1::Swagger::Models::Area
  include Swagger::Blocks

  swagger_schema :Area do
    key :required, [:id, :province_code]
    property :id do
      key :type, :string
      key :format, :uuid
    end
    property :province_code do
      key :type, :string
      # key :maxLength, 20
    end
    property :province_name do
      key :type, :string
    end
    property :district_code do
      key :type, :string
      # key :maxLength, 20
    end
    property :district_name do
      key :type, :string
    end
    property :commune_code do
      key :type, :string
      # key :maxLength, 20
    end
    property :commune_name do
      key :type, :string
    end
  end


end
