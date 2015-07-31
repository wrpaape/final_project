require 'test_helper'

class ARMethodsControllerTest < ActionController::TestCase
  setup do
    @a_r_method = a_r_methods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:a_r_methods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create a_r_method" do
    assert_difference('ARMethod.count') do
      post :create, a_r_method: { example: @a_r_method.example, source: @a_r_method.source, syntax: @a_r_method.syntax }
    end

    assert_redirected_to a_r_method_path(assigns(:a_r_method))
  end

  test "should show a_r_method" do
    get :show, id: @a_r_method
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @a_r_method
    assert_response :success
  end

  test "should update a_r_method" do
    patch :update, id: @a_r_method, a_r_method: { example: @a_r_method.example, source: @a_r_method.source, syntax: @a_r_method.syntax }
    assert_redirected_to a_r_method_path(assigns(:a_r_method))
  end

  test "should destroy a_r_method" do
    assert_difference('ARMethod.count', -1) do
      delete :destroy, id: @a_r_method
    end

    assert_redirected_to a_r_methods_path
  end
end
