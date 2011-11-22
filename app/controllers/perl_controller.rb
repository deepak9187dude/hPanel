class PerlController < ApplicationController
  def index
    render :text=> `perl #{Rails.root}/perls/datetime.pl localhost root sahilb`
  end

end
