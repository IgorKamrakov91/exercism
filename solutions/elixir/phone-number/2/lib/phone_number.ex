defmodule PhoneNumber do
  @doc """
  Remove formatting from a phone number if the given number is valid. Return an error otherwise.
  """
  @spec clean(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clean(raw) do
    with :ok <- validate_chars(raw),
         digits = String.replace(raw, ~r/[^0-9]/, ""),
         {:ok, number} <- parse_number(digits),
         :ok <- validate_area_code(number),
         :ok <- validate_exchange_code(number) do
      {:ok, number}
    end
  end

  defp validate_chars(raw) do
    if String.match?(raw, ~r/[^0-9-(). +]/) do
      {:error, "must contain digits only"}
    else
      :ok
    end
  end

  defp parse_number(digits) do
    case String.length(digits) do
      10 -> {:ok, digits}
      11 ->
        if String.starts_with?(digits, "1") do
          {:ok, String.slice(digits, 1, 10)}
        else
          {:error, "11 digits must start with 1"}
        end
      len when len < 10 -> {:error, "must not be fewer than 10 digits"}
      len when len > 11 -> {:error, "must not be greater than 11 digits"}
    end
  end

  defp validate_area_code(number) do
    case String.at(number, 0) do
      "0" -> {:error, "area code cannot start with zero"}
      "1" -> {:error, "area code cannot start with one"}
      _ -> :ok
    end
  end

  defp validate_exchange_code(number) do
    case String.at(number, 3) do
      "0" -> {:error, "exchange code cannot start with zero"}
      "1" -> {:error, "exchange code cannot start with one"}
      _ -> :ok
    end
  end
end
