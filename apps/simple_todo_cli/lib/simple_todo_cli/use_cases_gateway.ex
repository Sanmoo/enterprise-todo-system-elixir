defmodule SimpleTodoCli.UseCasesGateway do
  alias SimpleTodoCore.UseCases.{CreateTask, CreateTaskList, DeleteTask}
  alias SimpleTodoCore.UseCases.CreateTask.Deps, as: CreateTaskDeps
  alias SimpleTodoCore.UseCases.DeleteTask.Deps, as: DeleteTaskDeps
  alias SimpleTodoCore.UseCases.CreateTaskList.Deps, as: CreateTaskListDeps
  alias SimpleTodoCore.Entities.{Task, TaskList}
  alias SimpleTodoCli.Repositories.{CsvTaskListRepository, CsvTaskRepository}

  def create_task(props) do
    CreateTask.call(%CreateTaskDeps{task_repository: CsvTaskRepository}).(struct(Task, props))
  end

  def create_task_list(props) do
    CreateTaskList.call(%CreateTaskListDeps{task_list_repository: CsvTaskListRepository}).(
      struct(TaskList, props)
    )
  end

  def delete_task(%{id: id}) do
    DeleteTask.call(%DeleteTaskDeps{task_repository: CsvTaskRepository}).(id)
  end
end
