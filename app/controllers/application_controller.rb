class ApplicationController < ActionController::Base
  #protect_from_forgery with: :exception
  protect_from_forgery with: :null_session, except: :create

  before_action :set_locale
  before_action :set_paper_trail_whodunnit

  def default_url_options
    { locale: I18n.locale }
  end

#  private

    def set_locale
      I18n.locale = params[:locale] || I18n.default_locale
    end

end
