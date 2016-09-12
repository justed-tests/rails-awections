require 'test_helper'

class AuctionsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get auctions_create_url
    assert_response :success
  end

end
