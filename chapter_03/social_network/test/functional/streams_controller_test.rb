require 'test_helper'

class StreamsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:streams)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stream" do
    assert_difference('Stream.count') do
      post :create, :stream => { }
    end

    assert_redirected_to stream_path(assigns(:stream))
  end

  test "should show stream" do
    get :show, :id => streams(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => streams(:one).to_param
    assert_response :success
  end

  test "should update stream" do
    put :update, :id => streams(:one).to_param, :stream => { }
    assert_redirected_to stream_path(assigns(:stream))
  end

  test "should destroy stream" do
    assert_difference('Stream.count', -1) do
      delete :destroy, :id => streams(:one).to_param
    end

    assert_redirected_to streams_path
  end
end
