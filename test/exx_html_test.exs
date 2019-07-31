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

  test "module test with function to test params" do
    assert {:safe, iolist} = test_function(2)
    assert ~s(<div id="1">2</div>) == :erlang.iolist_to_binary(iolist)
  end

  def test_function(arg) do
    ~x(<Div id="1">#{arg}</Div>)
  end
end
