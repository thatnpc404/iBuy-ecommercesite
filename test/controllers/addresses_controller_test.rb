require "test_helper"

class AddressesControllerTest < ActionDispatch::IntegrationTest
  test "should get Index" do
    get addresses_Index_url
    assert_response :success
  end
end
