defmodule JigsawPuzzle do
  @doc """
  Fill in missing jigsaw puzzle details from partial data
  """

  @type format() :: :landscape | :portrait | :square
  @type t() :: %__MODULE__{
          pieces: pos_integer() | nil,
          rows: pos_integer() | nil,
          columns: pos_integer() | nil,
          format: format() | nil,
          aspect_ratio: float() | nil,
          border: pos_integer() | nil,
          inside: pos_integer() | nil
        }

  defstruct [:pieces, :rows, :columns, :format, :aspect_ratio, :border, :inside]

  @spec data(jigsaw_puzzle :: JigsawPuzzle.t()) ::
          {:ok, JigsawPuzzle.t()} | {:error, String.t()}
  def data(jigsaw_puzzle) do
    try do
      {:ok,
       %JigsawPuzzle{
         pieces: pieces(jigsaw_puzzle),
         rows: rows(jigsaw_puzzle),
         columns: columns(jigsaw_puzzle),
         aspect_ratio: aspect_ratio(jigsaw_puzzle),
         format: format(jigsaw_puzzle),
         border: border(jigsaw_puzzle),
         inside: inside(jigsaw_puzzle)
       }}
    rescue
      x in RuntimeError -> {:error, x.message}
      _ -> {:error, "Insufficient data"}
    end
  end

  defp pieces(%{pieces: p}) when p != nil, do: p
  defp pieces(o), do: rows(o) * columns(o)

  defp rows(%{rows: rows}) when rows != nil, do: rows

  defp rows(%{border: b, pieces: p} = o) when b != nil and p != nil do
    f = format(o)
    [k] = for r <- 1..ceil(:math.sqrt(p)), rem(p, r) == 0, r * 2 + div(p, r) * 2 - 4 == b, do: r
    (f == :portrait && div(p, k)) || k
  end

  defp rows(%{inside: i, aspect_ratio: 1.0}) when i != nil, do: round(:math.sqrt(i)) + 2
  defp rows(%{inside: i, format: :square}) when i != nil, do: round(:math.sqrt(i)) + 2

  defp rows(%{pieces: pieces} = o) when pieces != nil,
    do: round(:math.sqrt(pieces / aspect_ratio1(o)))

  defp rows(%{columns: columns} = o) when columns != nil, do: columns / aspect_ratio1(o)

  defp columns(%{columns: columns}) when columns != nil, do: columns
  defp columns(%{pieces: p} = o) when p != nil, do: p / rows(o)
  defp columns(o), do: rows(o) * aspect_ratio(o)
  defp aspect_ratio1(%{format: :square}), do: 1
  defp aspect_ratio1(%{pieces: p, rows: r}) when p != nil and r != nil, do: p / (r * r)
  defp aspect_ratio1(%{pieces: p, columns: c}) when p != nil and c != nil, do: c * c / p
  defp aspect_ratio1(%{aspect_ratio: a}) when a != nil, do: a
  defp aspect_ratio1(_), do: nil
  defp aspect_ratio2(a), do: columns(a) / rows(a)
  defp aspect_ratio(a), do: aspect_ratio1(a) || aspect_ratio2(a)

  defp format(%{format: f} = o) when f != nil do
    if o.rows != nil and o.columns != nil and f == :square and o.rows != o.columns do
      raise "Contradictory data"
    end

    f
  end

  defp format(f) do
    a = aspect_ratio(f)
    (a > 1 && :landscape) || (a == 1 && :square) || :portrait
  end

  defp border(x), do: rows(x) * 2 + columns(x) * 2 - 4
  defp inside(x), do: (rows(x) - 2) * (columns(x) - 2)
end
