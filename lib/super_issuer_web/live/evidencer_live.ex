defmodule SuperIssuerWeb.EvidencerLive do

  use Phoenix.LiveView
  alias SuperIssuerWeb.EvidencerView

  def render(assigns) do
    EvidencerView.render("evidencer.html", assigns)
  end

  def mount(_params, _session, socket) do
    {:ok,
    socket
    |> assign(form: :payloads)
  }
  end

  def handle_event("up_to_chain", payload, socket) do
    {:noreply,
    socket
    |> put_flash("info_A", "up to chain!successfully")
    |> put_flash("info_B", "key:")
  }
  end

  def handle_event(sth, payload, socket) do
    {:noreply, socket}
  end

end
