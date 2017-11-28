defmodule ElavonTest do
  use ExUnit.Case

  describe ".sale" do
    test "creates a transaction with valid card info" do
      params = %{
        ssl_card_number: 4124939999999990,
        ssl_cvv2cvc2_indicator: 1,
        ssl_cvv2cvc2: 123,
        ssl_amount: 10.00,
        ssl_exp_date: 1220
      }

      {:ok, transaction} = Elavon.sale(params)
    end
  end
end
