defmodule BullsWeb.BullsChannelTest do
  use BullsWeb.ChannelCase

  setup do
    {:ok, _, socket} =
      BullsWeb.UserSocket
      |> socket("user_id", %{some: :assign})
      |> subscribe_and_join(BullsWeb.BullsChannel, "bulls:lobby")

    %{socket: socket}
  end

  test "guess works", %{socket: socket} do
    ref = push(socket, "guess", %{"guess" => [1, 2, 3, 4]})
    assert_reply ref, :ok, %{
      digits: [7, 3, 5, 9],
      guesses: [[1, 2, 3, 4]],
      feedback: "",
      gamestate: "guessing"
    }
  end

  test "ping replies with status ok", %{socket: socket} do
    ref = push socket, "ping", %{"hello" => "there"}
    assert_reply ref, :ok, %{"hello" => "there"}
  end

  test "shout broadcasts to bulls:lobby", %{socket: socket} do
    push socket, "shout", %{"hello" => "all"}
    assert_broadcast "shout", %{"hello" => "all"}
  end

  test "broadcasts are pushed to the client", %{socket: socket} do
    broadcast_from! socket, "broadcast", %{"some" => "data"}
    assert_push "broadcast", %{"some" => "data"}
  end
end
