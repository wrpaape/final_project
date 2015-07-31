require 'test_helper'

class ActRecMethodsControllerTest < ActionController::TestCase
  setup do
    @act_rec_method = act_rec_methods(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:act_rec_methods)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create act_rec_method" do
    assert_difference('ActRecMethod.count') do
      post :create, act_rec_method: { description: @act_rec_method.description, example: @act_rec_method.example, module: @act_rec_method.module, name: @act_rec_method.name, source: @act_rec_method.source, syntax: @act_rec_method.syntax }
    end

    assert_redirected_to act_rec_method_path(assigns(:act_rec_method))
  end

  test "should show act_rec_method" do
    get :show, id: @act_rec_method
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @act_rec_method
    assert_response :success
  end

  test "should update act_rec_method" do
    patch :update, id: @act_rec_method, act_rec_method: { description: @act_rec_method.description, example: @act_rec_method.example, module: @act_rec_method.module, name: @act_rec_method.name, source: @act_rec_method.source, syntax: @act_rec_method.syntax }
    assert_redirected_to act_rec_method_path(assigns(:act_rec_method))
  end

  test "should destroy act_rec_method" do
    assert_difference('ActRecMethod.count', -1) do
      delete :destroy, id: @act_rec_method
    end

    assert_redirected_to act_rec_methods_path
  end
end
