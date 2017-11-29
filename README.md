# Elavon
[![Build Status](https://semaphoreci.com/api/v1/ir/elavon-elixir/branches/master/shields_badge.svg)](https://semaphoreci.com/ir/elavon-elixir)
[![Coverage Status](https://coveralls.io/repos/github/infinitered/elavon-elixir/badge.svg?branch=master)](https://coveralls.io/github/infinitered/elavon-elixir?branch=master)

A native [USBank Elavon Converge](https://developer.elavon.com/#/home/landing) elixir client. This library only supports a fraction of the full Elavon API, however what is written is production ready.

## Installation

Add `elavon` to your list of dependencies in `mix.exs` and run `mix deps.get`:

```elixir
def deps do
  [
    {:elavon, "~> 0.1.0"}
  ]
end
```

## Configuration

After `elavon` is installed, you'll need to add the appropriate configuration:

```
  config :elavon,
    environment: :sandbox,
    transaction_module: Elavon.Transaction.HTTP,
    ssl_merchant_id: System.get_env("ELAVON_MERCHANT_ID"),
    ssl_user_id: System.get_env("ELAVON_USER_ID"),
    ssl_pin: System.get_env("ELAVON_PIN"),
    custom_fields: [:Site, :EDate, :SDate]
```

The environment defaults to `:sandbox`, but you'll want to change it to `:production` in your `prod.exs` file.

The transaction module is configurable so that you can create a mock module for testing if necessary. For example:

```
  # Create Elavon.Transaction.Mock module
  defmodule Elavon.Transaction.Mock do
    def sale(params, opts) do
      # return a mocked response
    end
  end

  # Update test.exs config file:
  config :elavon,
    transaction_module: Elavon.Transaction.Mock
```

The custom fields configuration option allows you to specify any custom fields you've defined on your account, which you'd like to be returned as part of the transaction response.

## Usage

The test cards are not listed in the documentation and they may change in future. Here are the current mastercard and visa test card numbers:

**VISA**: 4124939999999990
**MASTERCARD**: 5406004444444443

```

  params = %{
    ssl_card_number: 4124939999999990,
    ssl_cvv2cvc2_indicator: 1,
    ssl_cvv2cvc2: 123,
    ssl_amount: 10.00,
    ssl_exp_date: 1220,
    ssl_invoice_number: to_string(Enum.take_random(?a..?z, 20))
  }

  case Elavon.sale(params) do
    {:ok, %Elavon.Transaction{} = transaction} -> do_something_with_transaction(transaction)
    {:error, %Elavon.Exception{} = error} -> report_error(error)
    {:error, %HTTPoison{id: nil, reason: :timeout}} -> handle_timeout()
  end
```

## Premium Support

Elavon, as an open source project, is free to use and always will be. [Infinite Red](https://infinite.red) offers premium Elavon support and general web &
mobile app design/development services. Get in touch [here](https://infinite.red/contact) or email us at [hello@infinite.red](mailto:hello@infinite.red).

![Infinite Red Logo](https://infinite.red/images/infinite_red_logo_colored.png)
