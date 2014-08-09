# Phoenix Template Engine for the django template language

> Powered by [erlydtl](https://github.com/erlydtl/erlydtl)

> Based on the [HAML template engine for phoenix](https://github.com/chrismccord/phoenix_haml)


## Usage

  1. Add `{:phoenix_dtl, "~> 0.0.1"}` to your mix deps
  2. Add the following your Phoenix `config/config.exs`

```elixir
  config :phoenix, :template_engines,
    dtl: PhoenixDtl.Engine
```
