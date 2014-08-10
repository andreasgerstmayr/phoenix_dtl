defmodule PhoenixDtl.Engine do
  @behaviour Phoenix.Template.Engine

  @doc """
  Precompiles the String file_path into a function defintion, using erlydtl engine

  For example, given "templates/show.html.dtl", returns an AST def of the form:

      def render("show.html", assigns \\ [])

  """
  def precompile(file_path, func_name) do
    result = :erlydtl.compile_file(String.to_char_list(file_path), String.to_char_list(func_name), [{:binary, true}, {:out_dir, false}])
    binary = case result do
      {:ok, module, binary} -> binary
      {:ok, module, binary, _warnings} -> binary
      :error -> raise Phoenix.Template.UndefinedError
      {:error, errors, _warnings} -> raise Phoenix.Template.UndefinedError, message: errors
    end

    quote bind_quoted: [func_name: func_name, binary: binary] do
      def render(unquote(func_name), assigns) do
        case :code.is_loaded(unquote(:"#{func_name}")) do
          false -> :code.load_binary(unquote(:"#{func_name}"), unquote(:"#{func_name}"), unquote(binary))
          _ ->
        end

        result = unquote(:"#{func_name}").render(PhoenixDtl.Util.convert_assignments(assigns))
        case result do
          {:ok, rendered} -> IO.iodata_to_binary(rendered)
          {:error, errors} -> raise Phoenix.Template.UndefinedError, message: errors
        end
      end
    end
  end

end
