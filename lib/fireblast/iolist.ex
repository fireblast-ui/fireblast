defprotocol Fireblast.Iolist do
  @fallback_to_any true
  def to_iolist(data, acc)
end

defimpl Fireblast.Iolist, for: ExXml.Element do
  def has_pre_process_children?({:__aliases__, [alias: the_alias], _}) do
    function_exported?(the_alias, :pre_process_children, 1)
  end

  def has_pre_process_children?(name) do
    function_exported?(name, :pre_process_children, 1)
  end

  def to_iolist(%{name: name, attributes: attributes, children: children, type: :module}, acc) do
    atom_module = String.to_atom("Elixir." <> name)
    module_alias = Keyword.get(acc.env.aliases, atom_module)

    module =
      if module_alias do
        Kernel.LexicalTracker.alias_dispatch(acc.env.lexical_tracker, atom_module)
        {:__aliases__, [alias: module_alias], [String.to_atom(name)]}
      else
        atom_module
      end

    IO.inspect(children)
    %{iolist: children_iolist, dynamic: children_dynamic} =
      children
      |> Enum.reduce(
        %{env: acc.env, iolist: [], dynamic: acc.dynamic},
        &Fireblast.Iolist.to_iolist/2
      )

    var = Macro.var(:"arg#{UUID.uuid4(:hex)}", acc.env.module)
    quoted_attributes = Fireblast.Util.map_to_quoted_map(attributes)

    ast_body =
      quote generated: true do
        apply(
          unquote(module),
          :render,
          [%{attributes: unquote(quoted_attributes), children: unquote(children_iolist)}]
        )
      end

    ast = quote do: {:safe, unquote(var)} = unquote(ast_body)
    %{acc | iolist: acc.iolist ++ [var], dynamic: children_dynamic ++ [ast]}
  end

  def to_iolist(
        %{name: name, attributes: attributes, children: [], type: :tag},
        %{iolist: iolist} = acc
      ) do
    %{
      acc
      | iolist:
          iolist ++
            List.flatten([
              "<#{name}",
              Enum.map(attributes, fn {key, value} -> [" #{key}=\"", value, "\""] end),
              "/>"
            ])
    }
  end

  def to_iolist(
        %{name: name, attributes: attributes, children: children, type: :tag},
        %{iolist: iolist} = acc
      ) do
    %{iolist: children_iolist, dynamic: children_dynamic} =
      children
      |> Enum.reduce(
        %{env: acc.env, iolist: [], dynamic: acc.dynamic},
        &Fireblast.Iolist.to_iolist/2
      )

    %{
      acc
      | iolist:
          iolist ++
            List.flatten([
              "<#{name}",
              Enum.map(attributes, fn {key, value} -> [" #{key}=\"", value, "\""] end),
              ">",
              children_iolist,
              "</#{name}>"
            ]),
        dynamic: children_dynamic
    }
  end
end

defimpl Fireblast.Iolist, for: ExXml.Fragment do
  def to_iolist(%{children: children}, acc) do
    children
    |> Enum.reduce(acc, &Fireblast.Iolist.to_iolist/2)
  end
end

defimpl Fireblast.Iolist, for: List do
  def to_iolist(list, acc) do
    list
    |> Enum.reduce(acc, &Fireblast.Iolist.to_iolist/2)
  end
end

defimpl Fireblast.Iolist, for: BitString do
  def to_iolist(binary, %{iolist: iolist} = acc) do
    %{acc | iolist: iolist ++ [binary]}
  end
end

defimpl Fireblast.Iolist, for: Tuple do
  def to_iolist({:safe, safe_iolist}, %{iolist: iolist} = acc) do
    %{acc | iolist: iolist ++ safe_iolist}
  end

  # for variables and function calls
  def to_iolist({atom_or_tuple, list, atom_or_list} = tuple, acc)
      when (is_atom(atom_or_tuple) and is_list(list) and is_atom(atom_or_list)) or
             (is_tuple(atom_or_tuple) and is_list(list) and is_list(atom_or_list)) do
    var = Macro.var(:"arg#{UUID.uuid4(:hex)}", acc.env.module)

    ast_body =
      quote generated: true do
        case unquote(tuple) do
          list when is_list(list) ->
            {:safe,
             Enum.flat_map(list, fn
               {:safe, list} -> list
               other -> [other]
             end)}

          {:safe, list} ->
            {:safe, list}

          other ->
            Phoenix.HTML.html_escape(other)
        end
      end

    ast = quote do: {:safe, unquote(var)} = unquote(ast_body)

    %{acc | iolist: acc.iolist ++ [var], dynamic: acc.dynamic ++ [ast]}
  end

  def to_iolist(tuple, %{iolist: iolist} = acc) do
    %{acc | iolist: iolist ++ [tuple]}
  end
end

defimpl Fireblast.Iolist, for: Any do
  def to_iolist(other, %{iolist: iolist} = acc) do
    %{acc | iolist: iolist ++ [to_string(other)]}
  end
end
