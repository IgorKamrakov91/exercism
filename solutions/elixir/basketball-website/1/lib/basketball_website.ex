defmodule BasketballWebsite do
  def extract_from_path(data, []) do
    data
  end

  def extract_from_path(data, [first | rest]) do
    case rest do
      [] -> data[first]
      _ -> extract_from_path(data[first], rest)
    end
  end

  def extract_from_path(data, path) when is_binary(path) do
    parts = String.split(path, ".")
    extract_from_path(data, parts)
  end

  def get_in_path(data, path) do
    keys = String.split(path, ".")
    get_in(data, keys)
  end
end
