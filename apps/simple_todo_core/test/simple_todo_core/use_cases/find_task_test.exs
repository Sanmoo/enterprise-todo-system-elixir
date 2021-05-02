defmodule SimpleTodoCore.UseCases.FindTaskTest do
  import Destructure

  # TODO: How to make it async?
  use ExUnit.Case, async: false

  alias SimpleTodoCore.Entities.Task
  alias SimpleTodoCore.UseCases.{FindTask, CreateTask}
  alias SimpleTodoCore.UseCases.CreateTask.Deps, as: CreateTaskDeps
  alias SimpleTodoCore.UseCases.FindTask.Deps, as: FindTaskDeps
  alias SimpleTodoCore.Utils.InMemoryTaskRepository

  setup do
    start_supervised!({ InMemoryTaskRepository, [] })
    common_map = %{task_repository: InMemoryTaskRepository}
    %{
      create_task: CreateTask.call(struct(CreateTaskDeps, common_map)),
      find_task: FindTask.call(struct(FindTaskDeps, common_map))
    }
  end

  @task_desc "my task"
  describe "when there is a task already created" do
    setup d%{create_task} do
      {:ok, created} = %Task{description: @task_desc} |> create_task.()
      %{task: created}
    end

    test "it finds a task", d%{task, find_task} do
      assert ^task = find_task.(task.id)
    end
  end
end
