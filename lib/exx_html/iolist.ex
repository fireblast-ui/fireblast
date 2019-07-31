defprotocol ExxHtml.Iolist do
  @fallback_to_any true
  def to_iolist(data, env)
end

defimpl ExxHtml.Iolist, for: Exx.Element do
  def to_iolist(%{name: name, attributes: attributes, children: children, type: :module}, env) do
    new_children =
      children
      |> Enum.flat_map(&(ExxHtml.Iolist.to_iolist(&1, env)))

    atom_module = String.to_atom("Elixir." <> name)
    module_alias = Keyword.get(env.aliases, atom_module)

    module = if module_alias do
      module_alias
    else
      atom_module
    end
    {:safe, iolist} = apply(module, :render, [%{attributes: attributes, children: new_children}])
    iolist
    |> List.flatten()
  end

  def to_iolist(%{name: name, attributes: attributes, children: children, type: :tag}, env) do
    new_children =
      children
      |> Enum.flat_map(&(ExxHtml.Iolist.to_iolist(&1, env)))

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
  def to_iolist(%{children: children}, env) do
    children
    |> Enum.flat_map(&(ExxHtml.Iolist.to_iolist(&1, env)))
  end
end

defimpl ExxHtml.Iolist, for: List do
  def to_iolist(list, env) do
    list
    |> Enum.flat_map(&(ExxHtml.Iolist.to_iolist(&1, env)))
  end
end

defimpl ExxHtml.Iolist, for: BitString do
  def to_iolist(binary, _) do
    [binary]
  end
end

defimpl ExxHtml.Iolist, for: Tuple do
  def to_iolist({:safe, iolist}, _) do
    iolist
  end

  # for variables
  def to_iolist({atom1, list, atom2} = tuple, _) when is_atom(atom1) and is_list(list) and is_atom(atom2) do
    [
      quote bind_quoted: [tuple: tuple] do
        if is_list(tuple) do
          tuple
        else
          to_string(tuple)
        end
      end
    ]
  end

  def to_iolist(tuple, _) do
    [ tuple ]
  end
end

defimpl ExxHtml.Iolist, for: Any do
  def to_iolist(other, _) do
    [to_string(other)]
  end
end
