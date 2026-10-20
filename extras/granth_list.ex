# Standalone sample; not part of the app build.
defmodule GranthList do
  def run do
    ["Gita", "Kabir Sagar", "Ved"]
    |> Enum.with_index(1)
    |> Enum.each(fn {g, i} -> IO.puts("#{i}. #{g}") end)
  end
end
# Granth list sample — prints titles in order.
# Granth list sam
