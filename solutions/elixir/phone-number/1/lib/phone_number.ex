defmodule PhoneNumber do
  @doc """
  Remove formatting from a phone number if the given number is valid. Return an error otherwise.
  """
  @spec clean(String.t()) :: {:ok, String.t()} | {:error, String.t()}
  def clean(raw) do
    digits = String.replace(raw, ~r/[^0-9]/, "")

    cond do
      String.match?(raw, ~r/[^0-9-(). +]/) ->
        {:error, "must contain digits only"}

      String.length(digits) < 10 ->
        {:error, "must not be fewer than 10 digits"}

      String.length(digits) > 11 ->
        {:error, "must not be greater than 11 digits"}

      String.match?(digits, ~r/^[^1].{10}$/) ->
        {:error, "11 digits must start with 1"}

      String.match?(digits, ~r/^1*0[0-9]{9}/) ->
        {:error, "area code cannot start with zero"}

      String.match?(digits, ~r/^11*[0-9]{9}$/) ->
        {:error, "area code cannot start with one"}

      String.match?(digits, ~r/^1*[2-9][0-9]{2}[0][0-9]{6}$/) ->
        {:error, "exchange code cannot start with zero"}

      String.match?(digits, ~r/^1*[2-9][0-9]{2}[1][0-9]{6}$/) ->
        {:error, "exchange code cannot start with one"}

      String.match?(digits, ~r/^1*[2-9][0-9]{2}[2-9][0-9]{6}$/) ->
        {:ok, String.slice(digits, -10, 10)}
    end
  end
end
