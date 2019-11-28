defmodule Fireblast.Util do
  alias ExXml.{Element, Fragment}

  def has_process_children?({:__aliases__, [alias: the_alias], _}) do
    # IO.puts("1 #{the_alias}")
    function_exported?(the_alias, :process_children, 2)
  end

  def has_process_children?(name) do
    # IO.puts("2 #{name}")
    function_exported?(name, :process_children, 2)
  end

  def call_process_children({:__aliases__, [alias: the_alias], _}, children, acc) do
    apply(the_alias, :process_children, [children, acc])
  end

  def call_process_children(name, children, acc) do
    apply(name, :process_children, [children, acc])
  end

  def map_to_quoted_map(map) when is_map(map) do
    do_map_to_quoted_map(map)
  end

  def walk_ex_xml(%struct{} = element, acc, fun)
      when struct in [Element, Fragment] and is_function(fun) do
    do_walk_ex_xml(element, acc, fun)
  end

  def walk_ex_xml(list, acc, fun) when is_list(list) and is_function(fun) do
    do_walk_ex_xml(list, acc, fun)
  end

  defp do_map_to_quoted_map(map) when is_map(map) do
    keyword_list =
      map
      |> Enum.to_list()
      |> do_map_to_quoted_map()

    {:%{}, [], keyword_list}
  end

  defp do_map_to_quoted_map(list) when is_list(list) do
    list
    |> Enum.map(&do_map_to_quoted_map/1)
  end

  defp do_map_to_quoted_map({key, value}) do
    {key, do_map_to_quoted_map(value)}
  end

  defp do_map_to_quoted_map(other) do
    other
  end

  defp do_walk_ex_xml(%struct{} = element, acc, fun) when struct in [Element, Fragment] do
    {new_element, new_acc} = fun.(element, acc)

    {new_children, new_acc} = do_walk_ex_xml(element.children, new_acc, fun)

    {Map.put(new_element, :children, new_children), new_acc}
  end

  defp do_walk_ex_xml(list, acc, fun) when is_list(list) do
    {new_list, new_acc} =
      list
      |> Enum.reduce({[], acc}, fn element, {acc_list, acc} ->
        {new_element, new_acc} = do_walk_ex_xml(element, acc, fun)
        {[new_element | acc_list], new_acc}
      end)

    {:lists.reverse(new_list), new_acc}
  end

  defp do_walk_ex_xml(other, acc, fun) do
    fun.(other, acc)
  end
end
