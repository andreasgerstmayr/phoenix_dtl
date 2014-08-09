defmodule PhoenixDtl.Util do

  @doc """
  Recursively converts maps and structs to proplists
  """
  def convert_assignments({key, value}) when is_map(value) and key != :conn do
    {key, convert_assignments(value)}
  end

  def convert_assignments({key, value}) when is_list(value) do
    {key, Enum.map(value, &convert_assignments/1)}
  end

  def convert_assignments(data) when is_map(data) do
    # structs don't implement the Enumerable protocol
    case Map.has_key?(data, :__struct__) do
      true -> Enum.map(Map.from_struct(data), &convert_assignments/1)
      false -> Enum.map(data, &convert_assignments/1)
    end
  end

  def convert_assignments(data) do
    data
  end
  
end
