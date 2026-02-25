defmodule SgfParsing do
  defmodule Sgf do
    defstruct properties: %{}, children: []
  end

  @type sgf :: %Sgf{properties: map, children: [sgf]}

  @doc """
  Parse a string into a Smart Game Format tree
  """
  @spec parse(encoded :: String.t()) :: {:ok, sgf} | {:error, String.t()}
  def parse(encoded) do
    case parse_tree_internal(encoded) do
      {:ok, sgf, ""} -> {:ok, sgf}
      {:ok, _sgf, _rest} -> {:error, "unexpected characters after tree"}
      {:error, _} = error -> error
    end
  end

  defp parse_tree_internal(input) do
    case input do
      "(" <> rest ->
        case rest do
          ")" <> _ ->
            {:error, "tree with no nodes"}

          ";" <> rest2 ->
            with {:ok, node, rest3} <- parse_node_and_children(rest2) do
              case rest3 do
                ")" <> rest4 -> {:ok, node, rest4}
                _ -> {:error, "tree unclosed"}
              end
            end

          _ ->
            {:error, "tree with no nodes"}
        end

      "" ->
        {:error, "tree missing"}

      _ ->
        {:error, "tree missing"}
    end
  end

  defp parse_node_and_children(input) do
    with {:ok, props, rest} <- parse_properties(input) do
      case rest do
        ";" <> rest2 ->
          with {:ok, child, rest3} <- parse_node_and_children(rest2) do
            {:ok, %Sgf{properties: props, children: [child]}, rest3}
          end

        "(" <> _ ->
          with {:ok, children, rest2} <- parse_variations(rest, []) do
            {:ok, %Sgf{properties: props, children: children}, rest2}
          end

        _ ->
          {:ok, %Sgf{properties: props}, rest}
      end
    end
  end

  defp parse_variations("(" <> _ = input, acc) do
    with {:ok, tree, rest} <- parse_tree_internal(input) do
      if String.starts_with?(rest, "(") do
        parse_variations(rest, [tree | acc])
      else
        {:ok, Enum.reverse([tree | acc]), rest}
      end
    end
  end

  defp parse_variations(rest, acc), do: {:ok, Enum.reverse(acc), rest}

  defp parse_properties(input, props \\ %{}) do
    case input do
      <<c::utf8, _rest::binary>> when (c >= ?A and c <= ?Z) or (c >= ?a and c <= ?z) ->
        with {:ok, key, rest2} <- parse_key(input),
             {:ok, values, rest3} <- parse_values(rest2) do
          parse_properties(rest3, Map.put(props, key, values))
        end

      _ ->
        {:ok, props, input}
    end
  end

  defp parse_key(input) do
    case Regex.run(~r/^[^\[;()]+/, input) do
      [key] ->
        if Regex.match?(~r/^[A-Z]+$/, key) do
          {:ok, key, String.slice(input, String.length(key)..-1//1)}
        else
          {:error, "property must be in uppercase"}
        end

      _ ->
        {:error, "property must be in uppercase"}
    end
  end

  defp parse_values("[" <> _ = input) do
    do_parse_values(input, [])
  end

  defp parse_values(input) do
    if String.match?(input, ~r/^[A-Z]+/) do
      {:error, "properties without delimiter"}
    else
      {:error, "properties without delimiter"}
    end
  end

  defp do_parse_values("[" <> rest, acc) do
    with {:ok, val, remaining} <- parse_one_value(rest) do
      if String.starts_with?(remaining, "[") do
        do_parse_values(remaining, acc ++ [val])
      else
        {:ok, acc ++ [val], remaining}
      end
    end
  end

  defp parse_one_value(input, acc \\ "") do
    case input do
      "]" <> rest ->
        {:ok, acc, rest}

      "\\" <> rest ->
        case rest do
          "\n" <> rest2 ->
            parse_one_value(rest2, acc)

          <<c::utf8, rest2::binary>> ->
            char = <<c::utf8>>

            if whitespace_not_newline?(char) do
              parse_one_value(rest2, acc <> " ")
            else
              parse_one_value(rest2, acc <> char)
            end

          "" ->
            {:error, "unclosed value"}
        end

      "\n" <> rest ->
        parse_one_value(rest, acc <> "\n")

      <<c::utf8, rest::binary>> ->
        char = <<c::utf8>>

        if whitespace_not_newline?(char) do
          parse_one_value(rest, acc <> " ")
        else
          parse_one_value(rest, acc <> char)
        end

      "" ->
        {:error, "unclosed value"}
    end
  end

  defp whitespace_not_newline?(c) do
    c != "\n" && Regex.match?(~r/\s/u, c)
  end
end
