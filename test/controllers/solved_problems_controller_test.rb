require 'test_helper'

class SolvedProblemsControllerTest < ActionController::TestCase
  setup do
    @solved_problem = solved_problems(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:solved_problems)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create solved_problem" do
    assert_difference('SolvedProblem.count') do
      post :create, solved_problem: { num_queries: @solved_problem.num_queries, problem_id: @solved_problem.problem_id, sol_char_count: @solved_problem.sol_char_count, solution: @solved_problem.solution, time_exec_total: @solved_problem.time_exec_total, time_query_avg: @solved_problem.time_query_avg, time_query_max: @solved_problem.time_query_max, time_query_min: @solved_problem.time_query_min, time_query_total: @solved_problem.time_query_total, user_id: @solved_problem.user_id }
    end

    assert_redirected_to solved_problem_path(assigns(:solved_problem))
  end

  test "should show solved_problem" do
    get :show, id: @solved_problem
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @solved_problem
    assert_response :success
  end

  test "should update solved_problem" do
    patch :update, id: @solved_problem, solved_problem: { num_queries: @solved_problem.num_queries, problem_id: @solved_problem.problem_id, sol_char_count: @solved_problem.sol_char_count, solution: @solved_problem.solution, time_exec_total: @solved_problem.time_exec_total, time_query_avg: @solved_problem.time_query_avg, time_query_max: @solved_problem.time_query_max, time_query_min: @solved_problem.time_query_min, time_query_total: @solved_problem.time_query_total, user_id: @solved_problem.user_id }
    assert_redirected_to solved_problem_path(assigns(:solved_problem))
  end

  test "should destroy solved_problem" do
    assert_difference('SolvedProblem.count', -1) do
      delete :destroy, id: @solved_problem
    end

    assert_redirected_to solved_problems_path
  end
end
