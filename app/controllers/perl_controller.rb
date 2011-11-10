class PerlController < ApplicationController
  def index
    render :text=> `perl #{Rails.root}/perls/test.pl localhost sahilb 22`
  end

end
