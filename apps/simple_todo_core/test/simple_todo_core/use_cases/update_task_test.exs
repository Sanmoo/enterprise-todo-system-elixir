defmodule SimpleTodoCore.UseCases.UpdateTaskTest do
  # TODO: How to make it async?
  use ExUnit.Case, async: false

  alias SimpleTodoCore.Entities.Task
  alias SimpleTodoCore.UseCases.{UpdateTask, CreateTask}
  alias SimpleTodoCore.UseCases.CreateTask.Deps, as: CreateTaskDeps
  alias SimpleTodoCore.UseCases.UpdateTask.Deps, as: UpdateTaskDeps
  alias SimpleTodoCore.Utils.InMemoryTaskRepository

  setup do
    start_supervised!({ InMemoryTaskRepository, [] })
    %{
      create_task: CreateTask.call(%CreateTaskDeps{task_repository: InMemoryTaskRepository}),
      update_task: UpdateTask.call(%UpdateTaskDeps{task_repository: InMemoryTaskRepository})
    }
  end

  @task_desc "my task"
  describe "when there is a task already created" do
    setup %{create_task: create_task} do
      {:ok, created} = %Task{description: @task_desc} |> create_task.()
      %{task: created}
    end

    test "validates an empty description", %{task: task, update_task: update_task} do
      result = 
        task 
          |> Map.put(:description, "")
          |> update_task.()
      assert {:error, [description: {msg, _}]} = result
      assert msg =~ "can't be blank"
    end

    test "it updates the task description", %{task: task, update_task: update_task} do
      result = 
        task 
          |> Map.put(:description, "my_new_desc")
          |> update_task.()
      assert :ok = result
    end

    test "it completes a task", %{task: task, update_task: update_task} do
      result = 
        task 
          |> Map.put(:done, true)
          |> update_task.()
      assert :ok = result
    end
  end
end
