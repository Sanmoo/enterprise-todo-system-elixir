defmodule SimpleTodoCli.TasksTest do
  use ExUnit.Case, async: false
  import ExUnit.CaptureIO
  alias SimpleTodoCli.Repositories.CsvTaskListRepository
  alias SimpleTodoCli.Repositories.CsvTaskRepository

  setup do
    File.rm(CsvTaskListRepository.file_name())
    File.rm(CsvTaskRepository.file_name())
    :ok
  end

  test "stodo new-task-list --name \"My Task List\"" do
    result =
      capture_io(fn ->
        SimpleTodoCli.Main.main(["new-task-list", "--name", "My Task List"])
      end)

    assert result == """
           +-------+--------------------+
           | :id   | :name              |
           +-------+--------------------+
           | 0     | "My Task List"     |
           +-------+--------------------+\n
           """
  end

  describe "when there is already a task list created" do
    setup do
      capture_io(fn ->
        SimpleTodoCli.Main.main(["new-task-list", "--name", "My Task List"])
      end)

      :ok
    end

    test "stodo new-task-list --name \"My Task List2\"" do
      result =
        capture_io(fn ->
          SimpleTodoCli.Main.main(["new-task-list", "--name", "My Task List"])
        end)

      assert result == """
             There is already a task list with the same name
             """
    end

    test "stodo new-task --task-list-id 0" do
      result =
        capture_io(fn ->
          SimpleTodoCli.Main.main([
            "new-task",
            "--description",
            "comprar 22 bananas",
            "--task-list-id",
            "0"
          ])
        end)

      assert result == """
             +--------------------------+---------+-------+-----------------+
             | :description             | :done   | :id   | :task_list_id   |
             +--------------------------+---------+-------+-----------------+
             | "comprar 22 bananas"     | false   | 0     | 0               |
             +--------------------------+---------+-------+-----------------+\n
             """
    end
  end
end
