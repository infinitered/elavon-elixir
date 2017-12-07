defmodule Elavon.Transaction.HTTP do
  use HTTPoison.Base

  alias Elavon.{
    Transaction,
    Exception
  }

  @behaviour Elavon.Transaction

  @opts [timeout: 30_000, recv_timeout: 30_000]

  def sale(params, opts \\ []) do
    unwrap post("/process.do", params, [], Keyword.merge(@opts, opts))
  end

  # HTTPoison Callbacks
  # -------------------

  def process_request_headers(_) do
    [
      {"Content-Type", "application/x-www-form-urlencoded"},
      {"Accept", "application/xml"},
    ]
  end

  def process_url(path) do
    env = Application.get_env(:elavon, :environment)

    if env == :sandbox do
      "https://demo.myvirtualmerchant.com/VirtualMerchantDemo" <> path
    else
      "https://www.myvirtualmerchant.com/VirtualMerchant" <> path
    end
  end

  def process_request_body(body) when is_map(body) do
    base_params = %{
      "ssl_merchant_id" => Application.get_env(:elavon, :ssl_merchant_id),
      "ssl_user_id" => Application.get_env(:elavon, :ssl_user_id),
      "ssl_pin" => Application.get_env(:elavon, :ssl_pin),
      "ssl_transaction_type" => "CCSALE",
      "ssl_result_format" => "ASCII",
      "ssl_show_form" => "false",
      "ssl_txn_currency_code" => "USD"
    }

    base_params
    |> Map.merge(body)
    |> URI.encode_query
  end

  def process_response_body(body) do
    with %{ssl_result: "0"} = result <- parse_ini(body) do
      struct(Transaction, result)
    else
      error ->
        error
        |> Map.to_list
        |> Exception.exception
    end
  end

  # Helpers
  # -------------------

  defp parse_ini(string) do
    string
    |> String.split("\n")
    |> Enum.filter(&String.contains?(&1, "="))
    |> Enum.map(fn line ->
        [key, value] = String.split(line, "=", parts: 2)
        key = String.trim(key) |> String.to_atom
        value = if String.trim(value) == "", do: nil, else: String.trim(value)
        {key, value}
       end)
    |> Enum.into(%{})
  end

  defp unwrap({:ok, %{body: %Transaction{} = body}}), do: {:ok, body}
  defp unwrap({:ok, %{body: %Exception{} = exception}}), do: {:error, exception}
  defp unwrap(other), do: other
end
