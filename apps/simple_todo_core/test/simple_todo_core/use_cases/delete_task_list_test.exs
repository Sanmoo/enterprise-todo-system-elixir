defmodule SimpleTodoCore.UseCases.DeleteTaskListTest do
  import Destructure

  # TODO: How to make it async?
  use ExUnit.Case, async: false

  alias SimpleTodoCore.Entities.{Task, TaskList}
  alias SimpleTodoCore.UseCases.{CreateTask, DeleteTaskList, FindAllTasksInList, CreateTaskList, FindTaskList}
  alias SimpleTodoCore.UseCases.CreateTask.Deps, as: CreateTaskDeps
  alias SimpleTodoCore.UseCases.CreateTaskList.Deps, as: CreateTaskListDeps
  alias SimpleTodoCore.UseCases.DeleteTaskList.Deps, as: DeleteTaskListDeps
  alias SimpleTodoCore.UseCases.FindAllTasksInList.Deps, as: FindAllTasksInListDeps
  alias SimpleTodoCore.UseCases.FindTaskList.Deps, as: FindTaskListDeps
  alias SimpleTodoCore.Utils.{InMemoryTaskRepository, InMemoryTaskListRepository}

  setup do
    start_supervised!({ InMemoryTaskRepository, [] })
    start_supervised!({ InMemoryTaskListRepository, [] })
    %{
      create_task: CreateTask.call(%CreateTaskDeps{task_repository: InMemoryTaskRepository}),
      find_all_tasks_in_list: FindAllTasksInList.call(%FindAllTasksInListDeps{task_repository: InMemoryTaskRepository}),
      delete_task_list: DeleteTaskList.call(%DeleteTaskListDeps{
        task_repository: InMemoryTaskRepository,
        task_list_repository: InMemoryTaskListRepository
      }),
      create_task_list: CreateTaskList.call(%CreateTaskListDeps{task_list_repository: InMemoryTaskListRepository}),
      find_task_list: FindTaskList.call(%FindTaskListDeps{task_list_repository: InMemoryTaskListRepository, task_repository: InMemoryTaskRepository})
    }
  end

  describe "when there are three tasks created for a given task list" do
    setup d%{create_task, create_task_list} do
      {:ok, created_task_list} = %TaskList{name: "test"} |> create_task_list.()
      for i <- 1..3, do: {:ok, _} = %Task{description: "o_#{i}", task_list_id: created_task_list.id} |> create_task.()
      %{task_list_id: created_task_list.id}
    end

    test "it destroys a task list and its tasks", d%{task_list_id, find_all_tasks_in_list, find_task_list, delete_task_list} do
      assert {:ok, [_ | _]} = find_all_tasks_in_list.(task_list_id)
      assert %TaskList{name: "test", tasks: [_ | _]} = find_task_list.(task_list_id)

      assert :ok == delete_task_list.(task_list_id)

      assert {:ok, []} = find_all_tasks_in_list.(task_list_id)
      assert nil == find_task_list.(task_list_id)
    end
  end
end
