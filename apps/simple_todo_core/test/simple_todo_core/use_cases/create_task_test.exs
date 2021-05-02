defmodule SimpleTodoCore.UseCases.CreateTaskTest do
  # TODO: How to make it async?
  use ExUnit.Case, async: false

  alias SimpleTodoCore.Entities.Task
  alias SimpleTodoCore.UseCases.CreateTask
  alias SimpleTodoCore.UseCases.CreateTask.Deps
  alias SimpleTodoCore.Utils.InMemoryTaskRepository

  setup do
    start_supervised!({ InMemoryTaskRepository, [] })
    :ok
  end

  test "validates an empty description" do
    empty_task = %Task{}
    return = CreateTask.call(%Deps{task_repository: InMemoryTaskRepository}).(empty_task)
    assert {:error, [description: {"can't be blank", _}]} = return
  end

  @testing_desc "abc"
  test "creates a task" do
    testing_task = %Task{description: @testing_desc}
    return = CreateTask.call(%Deps{task_repository: InMemoryTaskRepository}).(testing_task)
    assert {:ok, %Task{}} = return
  end

  describe "when there is already a task with description #{@testing_desc}" do
    setup do
      InMemoryTaskRepository.create(%Task{description: @testing_desc})
      :ok
    end

    test "it validates a repeated description" do
      testing_task = %Task{description: @testing_desc}
      return = CreateTask.call(%Deps{task_repository: InMemoryTaskRepository}).(testing_task)
      assert {:error, [description: {msg, _}]} = return
      assert msg =~ "same description"
    end
  end
end
