defmodule Elavon do
  @moduledoc """
  Provides functions to interact with USBank Elavon Converge API. You can configure the API
  with a mock for testing if necessary.

  ## Configuration

    config :elavon, api_module: Elavon.API.HTTP

  In test mode:

    config :elavon, api_module: Elavon.API.Mock
  """

  @doc """
  Creates a sale with the specified parameters.

  ## Examples

      #=> Elavon.sale(%{
        ssl_card_number: 4124939999999990,
        ssl_cvv2cvc2_indicator: 1,
        ssl_cvv2cvc2: 123,
        ssl_amount: 10.00,
        ssl_exp_date: 1220
      })
      {:ok, %Elavon.Transaction{}}
  """
  @spec sale(map, list) ::
    # {:ok, %Elavon.Transaction{}} |
    {:ok, map} |
    {:error, %Elavon.Exception{}} |
    {:error, map}
  def sale(params, opts \\ []) do
    transaction_module().sale(params, opts)
  end

  defp transaction_module do
    Application.get_env(:elavon, :transaction_module, Elavon.Transaction.HTTP)
  end
end
