class PerlController < ApplicationController
  def index
    render :text=> `perl #{Rails.root}/perls/test.pl`
  end

end
