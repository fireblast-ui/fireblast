defprotocol ExxHtml.Iolist do
  @fallback_to_any true
  def to_iolist(data)
end

defimpl ExxHtml.Iolist, for: Exx.Element do
  def to_iolist(%{name: name, attributes: attributes, children: children, type: :module}) do
    new_children =
      children
      |> Enum.flat_map(&ExxHtml.Iolist.to_iolist/1)

    {:safe, iolist} = apply(String.to_atom("Elixir." <> name), :render, [%{attributes: attributes, children: new_children}])
    iolist
    |> List.flatten()
  end

  def to_iolist(%{name: name, attributes: attributes, children: children, type: :tag}) do
    new_children =
      children
      |> Enum.flat_map(&ExxHtml.Iolist.to_iolist/1)

    [
      "<#{name}",
      Enum.map(attributes, fn {key, value} -> [" #{key}=\"", value, "\""] end),
      ">",
      new_children,
      "</#{name}>"
    ]
    |> List.flatten()
  end
end

defimpl ExxHtml.Iolist, for: Exx.Fragment do
  def to_iolist(%{children: children}) do
    children
    |> Enum.flat_map(&ExxHtml.Iolist.to_iolist/1)
  end
end

defimpl ExxHtml.Iolist, for: List do
  def to_iolist(list) do
    list
    |> Enum.flat_map(&ExxHtml.Iolist.to_iolist/1)
  end
end

defimpl ExxHtml.Iolist, for: BitString do
  def to_iolist(binary) do
    [binary]
  end
end

defimpl ExxHtml.Iolist, for: Tuple do
  def to_iolist({:safe, iolist}) do
    iolist
  end

  # for variables
  def to_iolist({atom1, list, atom2} = tuple) when is_atom(atom1) and is_list(list) and is_atom(atom2) do
    [
      quote do
        ExxHtml.Iolist.to_iolist(unquote(tuple))
      end
    ]
  end

  def to_iolist(tuple) do
    [ tuple ]
  end
end

defimpl ExxHtml.Iolist, for: Any do
  def to_iolist(other) do
    [to_string(other)]
  end
end
