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

  test "Mapping over of children" do
    list = [1, 2, 3]
    render_item = fn item ->
      {:safe, iolist} = ~x(<p>#{item}</p>)
      iolist
    end
    assert {:safe, iolist} = ~x(
      <div id="1">
        #{Enum.map(list, render_item)}
      </div>
    )
    assert ~s(<div id="1"><p>1</p><p>2</p><p>3</p></div>) == :erlang.iolist_to_binary(iolist)
  end

  def test_function(arg) do
    ~x(<Div id="1">#{arg}</Div>)
  end
end
