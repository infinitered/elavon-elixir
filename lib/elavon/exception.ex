defmodule Elavon.Exception do
  defexception [:code, :name, :message, :raw_body]

  def exception(error) do
    %__MODULE__{
      code: error[:errorCode] || error[:ssl_result],
      name: error[:errorName],
      message: error[:errorMessage] || error[:ssl_result_message],
      raw_body: error
    }
  end
end