require "test_helper"

class ProgressControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get progress_show_url
    assert_response :success
  end
end
