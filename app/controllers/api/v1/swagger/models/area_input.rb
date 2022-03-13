module Api::V1::Swagger::Models::AreaInput
  include Swagger::Blocks

  # swagger_schema :AreaInput do
  #   allOf do
  #     schema do
  #       key :'$ref', :Area
  #     end
  #     schema do
  #       key :required, [:province_code]
  #       property :id do
  #         key :type, :integer
  #         key :format, :int64
  #       end
  #     end
  #   end
  # end

  swagger_schema :AreaInput do
    allOf do
      # schema do
      #   key :'$ref', :Area
      # end
      schema do
        key :required, [:province_code, :province_name]
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
  end

end
