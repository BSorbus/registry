# config/initializers/paper_trail.rb

PaperTrail.config.enabled = true
PaperTrail.config.has_paper_trail_defaults = {
  on: %i[create update destroy]
}
PaperTrail.config.version_limit = nil
PaperTrail.config.track_associations = true

PaperTrail::Rails::Engine.eager_load!

module PaperTrail
  class Version < ::ActiveRecord::Base
    # belongs_to :user, foreign_key: :whodunnit
    belongs_to :author, class_name: "User", foreign_key: :whodunnit, optional: true
  end
end