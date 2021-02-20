defmodule BullsWeb.BullsChannel do
  use BullsWeb, :channel

  @impl true
  def join("bulls:" <> _id, payload, socket) do
    if authorized?(payload) do
      game = Bulls.Game.new()
      socket = assign(socket, :game, game)
      view = Bulls.Game.view(game)

      {:ok, view, socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  @impl true
  def handle_in("guess", guess, socket) do
    game0 = socket.assigns[:game]
    #socket = assign(socket, :game,
    #%{
    #  digits: [5, 6, 7, 8],
    #  guesses: [[1, 2, 3, 4]],
    #  feedback: "",
    #  gamestate: "guessing"
    #})
    game1 = Bulls.Game.guess(game0, guess)
    socket = assign(socket, :game, game1)
    view = Bulls.Game.view(game1)
    {:reply, {:ok, view}, socket}
  end

  @impl true
  def handle_in("reset", _payload, socket) do
    newgame = Bulls.Game.new()
    socket = assign(socket, :game, newgame)
    view = Bulls.Game.view(newgame)
    {:reply, {:ok, view}, socket}
  end

  # Channels can be used in a request/response fashion
  # by sending replies to requests from the client
  @impl true
  def handle_in("ping", payload, socket) do
    {:reply, {:ok, payload}, socket}
  end

  # It is also common to receive messages from the client and
  # broadcast to everyone in the current topic (bulls:lobby).
  @impl true
  def handle_in("shout", payload, socket) do
    broadcast socket, "shout", payload
    {:noreply, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
