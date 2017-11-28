defmodule Elavon.Exception do
  defexception [:code, :name, :message, :raw_body]

  def exception(error) do
    %__MODULE__{
      code: error[:errorCode],
      name: error[:errorName],
      message: error[:errorMessage],
      raw_body: error
    }
  end
end