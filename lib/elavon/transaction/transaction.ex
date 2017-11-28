defmodule Elavon.Transaction do
  @moduledoc """
  Behaviour module for Elavon API. Documentation can be found here:

  https://developer.elavon.com/#/api/eb6e9106-0172-4305-bc5a-b3ebe832f823.rcosoomi/versions/5180a9f2-741b-439c-bced-5c84a822f39b.rcosoomi/documents/index.html
  """

  @callback sale(map) ::
    {:ok, map} |
    {:error, Elavon.Exception}

  defstruct [:ssl_access_code, :ssl_account_balance, :ssl_account_status,
    :ssl_amount, :ssl_approval_code, :ssl_avs_response,
    :ssl_card_number, :ssl_card_type, :ssl_completion_date,
    :ssl_cvv2_response, :ssl_departure_date, :ssl_enrollment,
    :ssl_exp_date, :ssl_invoice_number, :ssl_issue_points,
    :ssl_loyalty_account_balance, :ssl_loyalty_program, :ssl_promo_code,
    :ssl_result, :ssl_result_message, :ssl_salestax, :ssl_tender_amount,
    :ssl_txn_id, :ssl_txn_time
  ] ++ Application.get_env(:elavon, :custom_fields, [])
end