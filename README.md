# Phoenix Template Engine for the django template language

> Powered by [erlydtl](https://github.com/erlydtl/erlydtl)

> Based on the [HAML template engine](https://github.com/chrismccord/phoenix_haml) for the [phoenix framework](https://github.com/phoenixframework/phoenix)

[![Build Status](https://api.travis-ci.org/andihit/phoenix_dtl.svg)](https://travis-ci.org/andihit/phoenix_dtl)

## Usage

  1. Add `{:phoenix_dtl, "~> 0.0.1"}` to your mix deps
  2. Add the following your Phoenix `config/config.exs`

```elixir
  config :phoenix, :template_engines,
    dtl: PhoenixDtl.Engine
```
