defprotocol ExxHtml.Iolist do
  @fallback_to_any true
  def to_iolist(data)
end

defimpl ExxHtml.Iolist, for: Exx.Element do
  def to_iolist(%{name: name, attributes: attributes, children: children, type: :module}) do
    new_children =
      children
      |> Enum.flat_map(&ExxHtml.Iolist.to_iolist/1)

    quoted_attributes = {:%{}, [], Enum.to_list(attributes)}
    quote do
      {:safe, iolist} = apply(String.to_atom("Elixir." <> unquote(name)), :render, [%{attributes: unquote(quoted_attributes), children: unquote(new_children)}])
      iolist
      |> List.flatten()
    end
    |> List.wrap()
  end

  def to_iolist(%{name: name, attributes: attributes, children: children, type: :tag}) do
    new_children =
      children
      |> Enum.flat_map(&ExxHtml.Iolist.to_iolist/1)

    [
      "<#{name}#{Enum.map(attributes, fn {key, value} -> " #{key}=\"#{value |> Kernel.to_string()}\"" end)}>",
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

  def to_iolist(tuple) do
    [tuple]
  end
end

defimpl ExxHtml.Iolist, for: Any do
  def to_iolist(other) do
    [to_string(other)]
  end
end
