defmodule Div do
  use ExxHtml

  def render(%{children: children}) do
    ~x(<div>#{children}</div>)
  end
end
