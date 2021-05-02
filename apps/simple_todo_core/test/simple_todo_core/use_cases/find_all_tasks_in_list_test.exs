defmodule SimpleTodoCore.UseCases.FindAllTasksInListTest do
  import Destructure

  # TODO: How to make it async?
  use ExUnit.Case, async: false

  alias SimpleTodoCore.Entities.Task
  alias SimpleTodoCore.UseCases.{FindAllTasksInList, CreateTask}
  alias SimpleTodoCore.UseCases.CreateTask.Deps, as: CreateTaskDeps
  alias SimpleTodoCore.UseCases.FindAllTasksInList.Deps, as: FindAllTasksInListDeps
  alias SimpleTodoCore.Utils.InMemoryTaskRepository

  setup do
    start_supervised!({ InMemoryTaskRepository, [] })
    %{
      create_task: CreateTask.call(%CreateTaskDeps{task_repository: InMemoryTaskRepository}),
      find_all_tasks_in_list: FindAllTasksInList.call(%FindAllTasksInListDeps{task_repository: InMemoryTaskRepository})
    }
  end

  @task_desc_prefix "my task"
  @task_list_id 1
  @other_task_list_id 2
  describe "when there are three tasks already created for the same task_list and another one for other task_list" do
    setup d%{create_task} do
      {:ok, first} = %Task{description: @task_desc_prefix <> "_1", task_list_id: @task_list_id} |> create_task.()
      {:ok, second} = %Task{description: @task_desc_prefix <> "_2", task_list_id: @task_list_id} |> create_task.()
      {:ok, third} = %Task{description: @task_desc_prefix <> "_3", task_list_id: @task_list_id} |> create_task.()
      {:ok, fourth} = %Task{description: @task_desc_prefix <> "_4", task_list_id: @other_task_list_id } |> create_task.()
      %{tasks_group_1: [first, second, third], tasks_groups_2: [fourth]}
    end

    test "it finds all tasks in list #{@task_list_id}", d%{tasks_group_1, find_all_tasks_in_list} do
      expected_task_set = MapSet.new(tasks_group_1)
      { :ok, actual_task_set } = find_all_tasks_in_list.(@task_list_id)
      assert ^expected_task_set = actual_task_set |> MapSet.new
    end
  end
end
