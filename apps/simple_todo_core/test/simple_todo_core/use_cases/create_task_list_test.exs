defmodule SimpleTodoCore.UseCases.CreateTaskListTest do
  use ExUnit.Case, async: false

  alias SimpleTodoCore.Entities.TaskList
  alias SimpleTodoCore.UseCases.CreateTaskList
  alias SimpleTodoCore.UseCases.CreateTaskList.Deps
  alias SimpleTodoCore.Utils.InMemoryTaskListRepository

  setup do
    start_supervised!(
      { InMemoryTaskListRepository, [] }
    )
    :ok
  end

  test "validates an empty name" do
    empty_task_list = %TaskList{}
    return = CreateTaskList.call(%Deps{task_list_repository: InMemoryTaskListRepository}).(empty_task_list)
    assert {:error, [name: {"can't be blank", _}]} = return
  end

  @list_name "abc"
  test "creates a task list" do
    task_list = %TaskList{name: @list_name}
    return = CreateTaskList.call(%Deps{task_list_repository: InMemoryTaskListRepository}).(task_list)
    assert {:ok, %TaskList{}} = return
  end

  describe "when there is already a task list with name #{@list_name}" do
    setup do
      InMemoryTaskListRepository.create(%TaskList{name: @list_name})
      :ok
    end

    test "it validates a repeated name" do
      task_list = %TaskList{name: @list_name}
      return = CreateTaskList.call(%Deps{task_list_repository: InMemoryTaskListRepository}).(task_list)
      assert {:error, [name: {msg, _}]} = return
      assert msg =~ "same name"
    end
  end
end

