class PerlController < ApplicationController
  def index
    render :text=> `perl #{Rails.root}/perls/datetime.pl`
  end

end
