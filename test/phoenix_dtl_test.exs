defmodule PhoenixDtlTest do
  use ExUnit.Case
  alias Phoenix.View

  defmodule MyApp.Templates do
    # setup config here because the templates get compiled before setup_all function is called
    Mix.Config.persist(phoenix: [
      {:template_engines,
        dtl: PhoenixDtl.Engine
      }
    ])

    use Phoenix.Template.Compiler, path: Path.join([__DIR__], "fixtures/templates")
  end

  defmodule User do
    defstruct name: "", points: 0
  end


  test "render a dtl template with layout" do
    template_data = %{
      "title" => "Welcome",
      "user" => %User{name: "John", points: 10},
      "welcome_message" => "Welcome!",
      within: {MyApp.Templates, "layouts/application.html"}
    }
    html = View.render(MyApp.Templates, "hello.html",
      template_data
    )
    assert html == "<html>\n  <head>\n    <title>Welcome</title>\n  </head>\n\n  <body>\n    Hello John!\nWelcome!\n\n  </body>\n</html>\n"
  end

  test "render a dtl template without layout" do
    template_data = %{
      "user" => %User{name: "John", points: 10},
      "welcome_message" => "Welcome!"
    }
    html = View.render(MyApp.Templates, "hello.html", template_data)
    assert html == "Hello John!\nWelcome!\n"
  end

  test "render a dtl template with a list" do
    template_data = %{
      "users" => [
        %User{name: "John", points: 20},
        %User{name: "Andi", points: 10},
        %User{name: "Hannah", points: 15}
      ]
    }
    html = View.render(MyApp.Templates, "list.html", template_data)
    assert html == "\nJohn\n\nAndi\n\nHannah\n\n"
  end
end
