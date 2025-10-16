defmodule Ledger do
  @doc """
  Format the given entries given a currency and locale
  """
  @type currency :: :usd | :eur
  @type locale :: :en_US | :nl_NL
  @type entry :: %{amount_in_cents: integer(), date: Date.t(), description: String.t()}

  @headers %{
    en_US: "Date       | Description               | Change       \n",
    nl_NL: "Datum      | Omschrijving              | Verandering  \n"
  }

  @currency_symbols %{
    usd: "$",
    eur: "€"
  }

  @spec format_entries(currency(), locale(), list(entry())) :: String.t()
  def format_entries(_, locale, []), do: @headers[locale]

  def format_entries(currency, locale, entries) do
    formatted_entries =
      entries
      |> sort_entries()
      |> Enum.map(&format_entry(currency, locale, &1))
      |> Enum.join("\n")

    @headers[locale] <> formatted_entries <> "\n"
  end

  defp sort_entries(entries) do
    Enum.sort(entries, fn a, b ->
      cond do
        a.date.day < b.date.day -> true
        a.date.day > b.date.day -> false
        a.description < b.description -> true
        a.description > b.description -> false
        true -> a.amount_in_cents <= b.amount_in_cents
      end
    end)
  end

  defp format_entry(currency, locale, entry) do
    date = format_date(locale, entry.date)
    description = format_description(entry.description)
    amount = format_amount(currency, locale, entry.amount_in_cents)

    Enum.join([date, "|", description, " |", amount])
  end

  defp format_date(locale, date) do
    year = date.year |> to_string()
    month = date.month |> to_string() |> String.pad_leading(2, "0")
    day = date.day |> to_string() |> String.pad_leading(2, "0")

    case locale do
      :en_US -> Enum.join([month, "/", day, "/", year, " "])
      :nl_NL -> Enum.join([day, "-", month, "-", year, " "])
    end
  end

  defp format_description(description) do
    if String.length(description) > 26 do
      " #{String.slice(description, 0, 22)}..."
    else
      " #{String.pad_trailing(description, 25, " ")}"
    end
  end

  defp format_amount(currency, locale, amount_in_cents) do
    currency_symbol = @currency_symbols[currency]
    number = format_number(locale, amount_in_cents)

    formatted =
      if amount_in_cents >= 0 do
        format_positive_amount(locale, currency_symbol, number)
      else
        format_negative_amount(locale, currency_symbol, number)
      end

    String.pad_leading(formatted, 14, " ")
  end

  defp format_number(locale, amount_in_cents) do
    whole = format_whole_number(locale, div(amount_in_cents, 100))
    decimal = calculate_decimal(amount_in_cents)

    case locale do
      :en_US -> "#{whole}.#{decimal}"
      :nl_NL -> "#{whole},#{decimal}"
    end
  end

  defp calculate_decimal(amount_in_cents) do
    amount_in_cents
    |> abs
    |> rem(100)
    |> to_string()
    |> String.pad_leading(2, "0")
  end

  defp format_whole_number(_locale, whole_number) when abs(whole_number) < 1000, do: whole_number |> abs() |> to_string()

  defp format_whole_number(locale, whole_number) do
    whole_number = abs(whole_number)
    thousands = div(whole_number, 1000)
    remainder = rem(whole_number, 1000) |> to_string() |> String.pad_leading(3, "0")

    case locale do
      :en_US -> "#{thousands},#{remainder}"
      :nl_NL -> "#{thousands}.#{remainder}"
    end
  end

  defp format_positive_amount(:en_US, currency_symbol, number) do
    "  #{currency_symbol}#{number} "
  end

  defp format_positive_amount(:nl_NL, currency_symbol, number) do
    " #{currency_symbol} #{number} "
  end

  defp format_negative_amount(:en_US, currency_symbol, number) do
    " (#{currency_symbol}#{number})"
  end

  defp format_negative_amount(:nl_NL, currency_symbol, number) do
    " #{currency_symbol} -#{number} "
  end
end
