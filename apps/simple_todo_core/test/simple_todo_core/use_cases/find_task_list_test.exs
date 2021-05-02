defmodule SimpleTodoCore.UseCases.FindTaskListTest do
  import Destructure

  # TODO: How to make it async?
  use ExUnit.Case, async: false

  alias SimpleTodoCore.Entities.{Task, TaskList}
  alias SimpleTodoCore.UseCases.{CreateTask, FindTaskList, FindAllTasksInList, CreateTaskList}
  alias SimpleTodoCore.UseCases.CreateTask.Deps, as: CreateTaskDeps
  alias SimpleTodoCore.UseCases.CreateTaskList.Deps, as: CreateTaskListDeps
  alias SimpleTodoCore.UseCases.FindAllTasksInList.Deps, as: FindAllTasksInListDeps
  alias SimpleTodoCore.UseCases.FindTaskList.Deps, as: FindTaskListDeps
  alias SimpleTodoCore.Utils.{InMemoryTaskRepository, InMemoryTaskListRepository}

  setup do
    start_supervised!({ InMemoryTaskRepository, [] })
    start_supervised!({ InMemoryTaskListRepository, [] })
    %{
      create_task: CreateTask.call(%CreateTaskDeps{task_repository: InMemoryTaskRepository}),
      find_all_tasks_in_list: FindAllTasksInList.call(%FindAllTasksInListDeps{task_repository: InMemoryTaskRepository}),
      create_task_list: CreateTaskList.call(%CreateTaskListDeps{task_list_repository: InMemoryTaskListRepository}),
      find_task_list: FindTaskList.call(%FindTaskListDeps{task_list_repository: InMemoryTaskListRepository, task_repository: InMemoryTaskRepository})
    }
  end

  describe "when there are three tasks created for a given task list" do
    setup d%{create_task, create_task_list} do
      {:ok, created_task_list} = %TaskList{name: "test"} |> create_task_list.()
      task_list_id = created_task_list.id
      created_tasks = for i <- 1..3 do
        {:ok, task} = %Task{description: "o_#{i}", task_list_id: task_list_id} |> create_task.()
        task
      end
      %{created_tasks: created_tasks, created_task_list: Map.put(created_task_list, :tasks, Enum.reverse(created_tasks))}
    end

    test "it finds a task list and its tasks", d%{find_all_tasks_in_list, find_task_list, created_tasks, created_task_list} do
      task_list_id = created_task_list.id
      {:ok, fetched_tasks} = find_all_tasks_in_list.(task_list_id)
      assert MapSet.new(created_tasks) == MapSet.new(fetched_tasks)
      assert ^created_task_list = find_task_list.(task_list_id)
    end
  end
end
