require 'test_helper'

class BabyNamesControllerTest < ActionController::TestCase
  setup do
    @baby_name = baby_names(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:baby_names)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create baby_name" do
    assert_difference('BabyName.count') do
      post :create, baby_name: {  }
    end

    assert_redirected_to baby_name_path(assigns(:baby_name))
  end

  test "should show baby_name" do
    get :show, id: @baby_name
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @baby_name
    assert_response :success
  end

  test "should update baby_name" do
    patch :update, id: @baby_name, baby_name: {  }
    assert_redirected_to baby_name_path(assigns(:baby_name))
  end

  test "should destroy baby_name" do
    assert_difference('BabyName.count', -1) do
      delete :destroy, id: @baby_name
    end

    assert_redirected_to baby_names_path
  end
end
