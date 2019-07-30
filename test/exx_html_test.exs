defmodule ExxHtmlTest do
  use ExUnit.Case
  doctest ExxHtml
  use ExxHtml

  test "simple test" do
    assert {:safe, iolist} = ~x(<div id="1">1</div>)
    assert ~s(<div id="1">1</div>) == :erlang.iolist_to_binary(iolist)
  end

  test "module test" do
    assert {:safe, iolist} = ~x(<Div id="1">1</Div>)
    assert ~s(<div id="1">1</div>) == :erlang.iolist_to_binary(iolist)
  end
end
