require 'test_helper'

class PerlControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
