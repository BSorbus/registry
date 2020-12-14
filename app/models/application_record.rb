class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def self.validate_nested_uniqueness_of(*nested_attrs)
    opts           = nested_attrs.extract_options!
    uniq_key       = opts[:uniq_key]
    case_sensitive = opts[:case_sensitive]
    scope          = opts[:scope    ] || []
    error_key      = opts[:error_key] || :nested_taken
    message        = opts[:message  ] || nil
    raise ArgumentError unless uniq_key.present?
    validates_each(nested_attrs) do |record, nested_attr, nested_values|
      dupes = Set.new
      nested_values.reject(&:marked_for_destruction?).map do |nested_val|
        dupe        = scope.each.inject({}) { |memo, (k)| memo[k] = nested_val.try(k); memo }
        dupe[uniq_key] = nested_val.try(uniq_key)
        dupe[uniq_key] = dupe[uniq_key].try(:downcase) if (case_sensitive == false && dupe[uniq_key].class == 'String')
        if dupes.member?(dupe)
          record.errors.add(:base, error_key, message: message)
        else
          dupes.add(dupe)
        end
      end
    end
  end

  # def self.validates_uniqueness(*attribute_names)
  #   configuration = attribute_names.extract_options!
  #   validates_each(attribute_names) do |record, association_name, value|
  #     track_values = {}
  #     track_values_ext = {}
  #     attribute_name = configuration[:attribute]
  #     value.map.with_index do |object, index|
  #       attribute_value = object.try(attribute_name)
  #       attribute_value = attribute_value.try(:downcase) if (configuration[:case_sensitive] == false && attribute_value.class == 'String')
  #       if track_values[attribute_value].present?
  #         track_values[attribute_value].push({index: index, record: record})
  #         track_values_ext[:worth].push({index: index, record: record})
  #       else
  #         track_values[attribute_value] = [{index: index, record: record}]
  #         track_values_ext[:worth] = [{index: index, record: record}]
  #       end
  #       track_values.each do |key, track_value|
  #         if track_value.count > 1
  #           track_value.each do |value|
  #             error_key = "#{association_name}[#{value[:index]}].#{attribute_name}"
  #             message = configuration[:message] || I18n.t('nested_taken')
  #             value[:record].errors.add(error_key, message)
  #           end
  #         end
  #       end
  #     end
  #   end
  # end

end
