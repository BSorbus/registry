class Representative < ApplicationRecord
 
  # relations
  belongs_to :representative_type, class_name: "FeatureType", inverse_of: :representative_type_representatives
  belongs_to :organization
 
  has_many :addresses, as: :addressable, dependent: :destroy
  has_many :features, as: :featurable, dependent: :destroy

  # only for Work.log
  has_many :feature_address_exts, -> { self.feature_only_address_ext_type }, class_name: "Feature", as: :featurable


  has_paper_trail versions: {
    # class_name: 'RepresentativeVersion'
    # scope: -> { order("id desc") }
  }

  # validates
  validates :representative_type, presence: true
  validates :first_name, presence: true,
                    length: { in: 1..50 }
  validates :last_name, presence: true,
                    length: { in: 1..50 }

  validate :addresses_address_type_correspondence_presence
  validate :features_address_ext_type_email_presence


  validate_nested_uniqueness_of :addresses, uniq_key: :address_type_id, scope: [:addressable], case_sensitive: false, error_key: :addresses_address_type_nested_taken
  validate_nested_uniqueness_of :features, uniq_key: :feature_type_id, scope: [:featurable], case_sensitive: false, error_key: :nested_taken


  # callbacks


  # nested
  accepts_nested_attributes_for :addresses, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :features, reject_if: :all_blank, allow_destroy: true


  private

    def addresses_address_type_correspondence_presence
      if addresses.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_address_type_correspondence.ids.include?(x.address_type_id) }.empty?
        empty_key_names = FeatureType.only_address_type_correspondence.pluck(:name).flatten
        errors.add(:base, :addresses_address_type_correspondence_blank, data: empty_key_names)
      end
    end

    def features_address_ext_type_email_presence
      if features.reject(&:marked_for_destruction?).reject { |x| not FeatureType.only_address_ext_type_email.ids.include?(x.feature_type_id) }.empty?
        empty_key_names = FeatureType.only_address_ext_type_email.pluck(:name).flatten
        errors.add(:base, :features_address_ext_type_email_blank, data: empty_key_names)
        # throw :abort 
      end
    end


end
