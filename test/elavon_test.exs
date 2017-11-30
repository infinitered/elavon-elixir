defmodule ElavonTest do
  use ExUnit.Case

  @visa 4124939999999990
  @mastercard 5406004444444443
  @invalid 0000000000000000

  describe ".sale" do
    test "creates a transaction with valid card info" do
      params = %{
        ssl_card_number: @visa,
        ssl_cvv2cvc2_indicator: 1,
        ssl_cvv2cvc2: 123,
        ssl_amount: 10.00,
        ssl_exp_date: 1220,
        ssl_invoice_number: to_string(Enum.take_random(?a..?z, 20))
      }

      {:ok, %Elavon.Transaction{} = t} = Elavon.sale(params)

      assert t.ssl_amount == "10.00"
      assert t.ssl_card_number == "41**********9990"
      assert t.ssl_card_type == "CREDITCARD"
      assert t.ssl_exp_date == "1220"
      assert t.ssl_result_message == "APPROVAL"
      assert t.ssl_result == "0"
      assert t.ssl_txn_id
      assert t.ssl_txn_time
    end

    test "handles invalid card error" do
      params = %{
        ssl_card_number: @invalid,
        ssl_cvv2cvc2_indicator: 1,
        ssl_cvv2cvc2: 123,
        ssl_amount: 10.00,
        ssl_exp_date: 1220
      }

      {:error, %Elavon.Exception{} = e} = Elavon.sale(params)

      assert e.code == "9999"
      assert e.name == "Only Test Cards Allowed"
      assert e.message == "Only Test Cards Allowed in this environment"
      assert e.raw_body
    end

    test "handles invalid cvv" do
      params = %{
        ssl_card_number: @mastercard,
        ssl_cvv2cvc2_indicator: 1,
        ssl_cvv2cvc2: 6,
        ssl_amount: 10.00,
        ssl_exp_date: 1220
      }

      {:error, %Elavon.Exception{} = e} = Elavon.sale(params)

      assert e.code == "5021"
      assert e.name == "Invalid CVV2 Value"
      assert e.message == "The value for the CVV2 (ssl_cvv2cvc2) field should either be 3 or 4 digits in length.  This value must be Numeric."
    end

    test "handles duplicate orders" do
      params = %{
        ssl_card_number: @visa,
        ssl_cvv2cvc2_indicator: 1,
        ssl_cvv2cvc2: 123,
        ssl_amount: 10.00,
        ssl_exp_date: 1220,
        ssl_invoice_number: to_string(Enum.take_random(?a..?z, 20))
      }

      {:ok, %Elavon.Transaction{} = t} = Elavon.sale(params)
      {:error, %Elavon.Exception{} = e} = Elavon.sale(params)

      assert t.ssl_amount == "10.00"
      assert t.ssl_card_number == "41**********9990"
      assert t.ssl_card_type == "CREDITCARD"
      assert t.ssl_exp_date == "1220"
      assert t.ssl_result_message == "APPROVAL"
      assert t.ssl_result == "0"
      assert t.ssl_invoice_number == params.ssl_invoice_number
      assert t.ssl_txn_id
      assert t.ssl_txn_time

      assert e.code == "1"
      assert e.message == "Declined - Transaction previously authorized"
    end

    test "handles httpoison timeouts" do
      opts = [timeout: 1, recv_timeout: 1]

      params = %{
        ssl_card_number: @visa,
        ssl_cvv2cvc2_indicator: 1,
        ssl_cvv2cvc2: 123,
        ssl_amount: 10.00,
        ssl_exp_date: 1220,
        ssl_invoice_number: to_string(Enum.take_random(?a..?z, 20))
      }

      {:error, %HTTPoison.Error{id: nil, reason: :timeout}} = Elavon.sale(params, opts)
    end

    test "handles invoice number to long error" do
      params = %{
        ssl_card_number: @visa,
        ssl_cvv2cvc2_indicator: 1,
        ssl_cvv2cvc2: 123,
        ssl_amount: 10.00,
        ssl_exp_date: 1220,
        ssl_invoice_number: "asdflkjasdlfjaskldfjalskdjfklasjdflkasjdflkajsdfkljasldkfjalskdjf"
      }

      {:error, %Elavon.Exception{} = e} = Elavon.sale(params)

      assert e.code == "5005"
      assert e.name == "Field Character Limit Exceeded"
    end
  end
end
