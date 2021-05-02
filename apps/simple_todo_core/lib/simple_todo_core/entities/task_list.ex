defmodule SimpleTodoCore.Entities.TaskList do
  use Ecto.Schema
  alias SimpleTodoCore.Entities.Task

  embedded_schema do
    field :name, :string
    embeds_many :tasks, Task
  end

  use SimpleTodoCore.Entities.Base

  def validations(from, to) do
    change(from, to) |> validate_required([:name])
  end
end
