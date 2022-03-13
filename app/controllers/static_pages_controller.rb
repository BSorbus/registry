class StaticPagesController < ApplicationController

  caches_page :home, :home_alert, :gzip => :best_speed

  def home
  end

  def home_alert
  end

end
