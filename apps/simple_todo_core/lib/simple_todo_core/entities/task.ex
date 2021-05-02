defmodule SimpleTodoCore.Entities.Task do
  use Ecto.Schema

  embedded_schema do
    field :description, :string
    field :done, :boolean, default: false
    field :task_list_id, :integer, default: nil
  end

  use SimpleTodoCore.Entities.Base

  def validations(from, to) do
    change(from, to) |> validate_required([:description])
  end
end
