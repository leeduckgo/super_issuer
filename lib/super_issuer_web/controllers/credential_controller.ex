defmodule SuperIssuerWeb.CredentialController do
  use SuperIssuerWeb, :controller

  def index(conn, params) do
    credential =
      conn
      |> get_session(:credential)
    render(
      clean_session(conn),
      "index.html",
      credential
      )
  end

  def clean_session(conn) do
    conn
    |> fetch_session()
    |> delete_session(:credential)
  end
end
