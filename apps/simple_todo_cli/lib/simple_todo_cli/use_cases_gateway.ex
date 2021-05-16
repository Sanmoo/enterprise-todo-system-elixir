defmodule SimpleTodoCli.UseCasesGateway do
  alias SimpleTodoCore.UseCases.{CreateTask, CreateTaskList}
  alias SimpleTodoCore.UseCases.CreateTask.Deps, as: CreateTaskDeps
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
end
