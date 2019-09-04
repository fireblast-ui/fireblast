defmodule FireblastTest do
  use ExUnit.Case
  doctest Fireblast
  import Fireblast

  alias Fireblast.{TestComponent, MyCounter, DashboardUnit, Scoreboard}

  test "simple test" do
    assert {:safe, iolist} = ~x(<div id="1">1</div>)
    assert ~s(<div id="1">1</div>) == :erlang.iolist_to_binary(iolist)
  end

  test "module test" do
    assert {:safe, iolist} = ~x(<TestComponent id="1">1</TestComponent>)
    assert ~s(<div id="1">1</div>) == :erlang.iolist_to_binary(iolist)
  end

  test "module test with function to test params" do
    assert {:safe, iolist} = test_function(2)
    assert ~s(<div id="1">2</div>) == :erlang.iolist_to_binary(iolist)
  end

  test "Mapping over of children" do
    list = [1, 2, 3]

    render_item = fn item ->
      ~x(<p>#{item}</p>)
    end

    assert {:safe, iolist} = ~x(
      <div id="1">
        #{Enum.map(list, render_item)}
      </div>
    )
    assert ~s(<div id="1"><p>1</p><p>2</p><p>3</p></div>) == :erlang.iolist_to_binary(iolist)
  end

  # From http://buildwithreact.com/tutorial/jsx
  test "react test" do
    game_scores = %{
      player1: 2,
      player2: 5
    }

    assert {:safe, _} = ~x(
      <>
        <div class_name="red">Children Text</div>
        <MyCounter count=#{3 + 5} />
        <DashboardUnit data_index="2">
          <h1>Scores</h1>
          <Scoreboard class_name="results" scores=#{game_scores} />
        </DashboardUnit>
      </>
    )
  end

  # From https://github.com/tastejs/todomvc/blob/gh-pages/examples/react/js/footer.jsx
  test "more react test" do
    {:safe, clear_button} = ~x(
      <button
        class_name="clear-completed"
        on_click=#{fn _ -> nil end}>
        Clear completed
      </button>
    )

    now_showing = "ALL_TODOS"
    count = 5
    active_todo_word = if count > 1, do: "items", else: "item"

    assert {:safe, _} = ~x(
      <footer class_name="footer">
        <span class_name="todo-count">
        <strong>#{count}</strong> #{active_todo_word} left
          </span>
        <ul class_name="filters">
        <li>
        <a
          href="#/"
          class_name=#{if now_showing === "ALL_TODOS", do: "selected", else: nil}>
            All
          </a>
        </li>
        #{" "}
        <li>
        <a
          href="#/active"
          class_name=#{if now_showing === "ACTIVE_TODOS", do: "selected", else: nil}>
          Active
        </a>
        </li>
          #{" "}
        <li>
        <a
          href="#/completed"
          class_name=#{if now_showing === "COMPLETED_TODOS", do: "selected", else: nil}>
            Completed
          </a>
        </li>
        </ul>
        #{clear_button}
      </footer>
    )
  end

  def test_function(arg) do
    ~x(<TestComponent id="1">#{arg}</TestComponent>)
  end
end
