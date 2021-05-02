defmodule SimpleTodoCore.UseCases.DeleteTaskTest do
  import Destructure

  # TODO: How to make it async?
  use ExUnit.Case, async: false

  alias SimpleTodoCore.Entities.Task
  alias SimpleTodoCore.UseCases.{DeleteTask, CreateTask, FindTask}
  alias SimpleTodoCore.UseCases.CreateTask.Deps, as: CreateTaskDeps
  alias SimpleTodoCore.UseCases.DeleteTask.Deps, as: DeleteTaskDeps
  alias SimpleTodoCore.UseCases.FindTask.Deps, as: FindTaskDeps
  alias SimpleTodoCore.Utils.InMemoryTaskRepository

  setup do
    start_supervised!({ InMemoryTaskRepository, [] })
    common_map = %{task_repository: InMemoryTaskRepository}
    %{
      create_task: CreateTask.call(struct(CreateTaskDeps, common_map)),
      delete_task: DeleteTask.call(struct(DeleteTaskDeps, common_map)),
      find_task: FindTask.call(struct(FindTaskDeps, common_map))
    }
  end

  @task_desc "my task"
  describe "when there is a task already created" do
    setup d%{create_task} do
      {:ok, created} = %Task{description: @task_desc} |> create_task.()
      %{task_id: created.id}
    end

    test "it destroys a task", d%{task_id, delete_task, find_task} do
      assert nil != find_task.(task_id)
      assert :ok == delete_task.(task_id)
      assert nil == find_task.(task_id)
    end
  end
end
