require 'test_helper'

class FriendshipsControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:friendships)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create friendship" do
    assert_difference('Friendship.count') do
      post :create, :friendship => { }
    end

    assert_redirected_to friendship_path(assigns(:friendship))
  end

  test "should show friendship" do
    get :show, :id => friendships(:one).to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => friendships(:one).to_param
    assert_response :success
  end

  test "should update friendship" do
    put :update, :id => friendships(:one).to_param, :friendship => { }
    assert_redirected_to friendship_path(assigns(:friendship))
  end

  test "should destroy friendship" do
    assert_difference('Friendship.count', -1) do
      delete :destroy, :id => friendships(:one).to_param
    end

    assert_redirected_to friendships_path
  end
end
