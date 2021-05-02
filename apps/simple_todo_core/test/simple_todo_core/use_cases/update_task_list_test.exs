defmodule SimpleTodoCore.UseCases.UpdateTaskListTest do
  import Destructure
  use ExUnit.Case, async: false

  alias SimpleTodoCore.Entities.TaskList
  alias SimpleTodoCore.UseCases.UpdateTaskList
  alias SimpleTodoCore.UseCases.UpdateTaskList.Deps, as: UpdateTaskListDeps
  alias SimpleTodoCore.Utils.InMemoryTaskListRepository

  setup do
    start_supervised!(
      { InMemoryTaskListRepository, [] }
    )
    :ok
  end

  @list_name "abc"
  describe "when there is already a task list with name #{@list_name}" do
    setup do
      {:ok, created_task_list} = InMemoryTaskListRepository.create(%TaskList{name: @list_name})
      %{created_task_list: created_task_list}
    end

    test "validates an empty name when trying to update", d%{created_task_list} do
      updated_task_list = Map.put(created_task_list, :name, "")
      return = UpdateTaskList.call(%UpdateTaskListDeps{task_list_repository: InMemoryTaskListRepository}).(updated_task_list)
      assert {:error, [name: {"can't be blank", _}]} = return
    end

    @list_name2 "abc2"
    test "it validates a repeated name when trying to update", d%{created_task_list} do
      {:ok, _} = InMemoryTaskListRepository.create(%TaskList{name: @list_name2})
      updated_task_list = Map.put(created_task_list, :name, @list_name2)
      return = UpdateTaskList.call(%UpdateTaskListDeps{task_list_repository: InMemoryTaskListRepository}).(updated_task_list)
      assert {:error, [name: {msg, _}]} = return
      assert msg =~ "same name"
    end
    
    test "it updates a task list successfully when there are no validation errors", d%{created_task_list} do
      {:ok, _} = InMemoryTaskListRepository.create(%TaskList{name: @list_name2})
      updated_task_list = Map.put(created_task_list, :name, "other_name")
      return = UpdateTaskList.call(%UpdateTaskListDeps{task_list_repository: InMemoryTaskListRepository}).(updated_task_list)
      assert :ok = return
    end

    test "it updates a task list successfully when name does not change" do
      {:ok, task} = InMemoryTaskListRepository.create(%TaskList{name: @list_name2})
      return = UpdateTaskList.call(%UpdateTaskListDeps{task_list_repository: InMemoryTaskListRepository}).(task)
      assert :ok = return
    end
  end
end

