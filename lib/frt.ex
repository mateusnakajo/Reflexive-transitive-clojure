defmodule FRT do
  @moduledoc """
  A reflexive transitive closure module.
  """
  
  @doc """
  Returns the reflexive transitive clojure

  ## Parameters
    - relation: binary relation R
    - set: set A such that R ⊆ A × A

  ## Examples 
    iex> FRT.of([{:a, :b}, {:b, :c}], [:a, :b, :c])
    [a: :a, a: :b, a: :c, b: :b, b: :c, c: :c]
  """
  def of(relation, set) do
    reflexive(set) ++ transitive(relation, set) |> Enum.uniq() |> Enum.sort()
  end

  defp find_conections(node, already_reached, relation) do
    if(node in already_reached) do
      []
    else
      edges_from_node = Enum.filter(relation, &(elem(&1, 0) == node))
      if edges_from_node == [] do
        []
      else
        paths = Enum.map(edges_from_node,
                         &([elem(&1,1)] ++ find_conections(elem(&1,1),
                         [node] ++ already_reached, relation)))
        Enum.reduce(paths, &(&1 ++ &2))
      end
    end
  end

  defp transitive(relation, set) do
    paths = Enum.map(
      set,
      fn(x) ->
        list = find_conections(x, [], relation)
        Enum.map(list, &({x,&1}))
      end)
      Enum.reduce(paths, [], &(&1 ++ &2))
  end
  
  defp reflexive(set) do
    Enum.map(set, &({&1, &1}))
  end
end
