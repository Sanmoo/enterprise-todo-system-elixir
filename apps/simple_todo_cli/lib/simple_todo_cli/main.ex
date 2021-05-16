defmodule SimpleTodoCli.Main do
  alias SimpleTodoCli.UseCasesGateway

  def main(args) do
    options = [
      switches: [name: :string, task_list_id: :string, description: :string],
      aliases: [n: :name]
    ]

    {opts, _, _} = OptionParser.parse(args, options)

    result =
      case Enum.at(args, 0) do
        "new-task-list" ->
          UseCasesGateway.create_task_list(%{name: opts[:name]})

        "new-task" ->
          UseCasesGateway.create_task(%{
            task_list_id: Integer.parse(opts[:task_list_id], 10) |> elem(0),
            description: opts[:description]
          })

        "delete-task" ->
          UseCasesGateway.delete_task(%{
            id: Integer.parse(opts[:id], 10) |> elem(0)
          })
      end

    handle_response(result)
  end

  defp handle_response({:ok, result}) do
    Scribe.print(result, data: Map.keys(result) |> List.delete_at(0) |> List.delete(:tasks), colorize: false)
  end

  defp handle_response(:ok) do
    IO.puts("OK")
  end

  defp handle_response({:error, [{_, {msg, _}} | _]}) do
    IO.puts(msg)
  end
end
