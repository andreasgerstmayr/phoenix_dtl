defmodule PhoenixDtl.Engine do
  @behaviour Phoenix.Template.Engine

  @doc """
  Precompiles the String file_path into a function defintion, using erlydtl engine

  For example, given "templates/show.html.dtl", returns an AST def of the form:

      def render("show.html", assigns \\ [])

  """
  def precompile(file_path, func_name) do
    module_name = file_path_to_module_name(file_path)
    result = :erlydtl.compile_file(String.to_char_list(file_path), module_name, [{:binary, true}, {:out_dir, false}])
    binary = case result do
      {:ok, _module, binary} -> binary
      {:ok, _module, binary, _warnings} -> binary
      :error -> raise Phoenix.Template.UndefinedError
      {:error, errors, _warnings} -> raise Phoenix.Template.UndefinedError, message: errors
    end

    quote bind_quoted: [func_name: func_name, module_name: module_name, binary: binary] do
      def render(unquote(func_name), assigns) do
        case :code.is_loaded(unquote(module_name)) do
          false -> :code.load_binary(unquote(module_name), unquote(module_name), unquote(binary))
          _ ->
        end

        result = unquote(module_name).render(PhoenixDtl.Util.convert_assignments(assigns))
        case result do
          {:ok, rendered} -> IO.iodata_to_binary(rendered)
          {:error, errors} -> raise Phoenix.Template.UndefinedError, message: errors
        end
      end
    end
  end

  defp sha256(str) do
    hash = :crypto.hash(:sha256, str)
    hex = for <<b <- hash>>, do: :io_lib.format("~2.16.0b", [b])
    List.flatten(hex)
  end

  defp file_path_to_module_name(file_path) do
    hash = sha256(file_path)
    :"template_#{hash}"
  end

end
