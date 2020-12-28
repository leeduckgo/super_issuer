defmodule SuperIssuerWeb.CredentialController do
  use SuperIssuerWeb, :controller

  def index(conn, params) do
    credential =
      conn
      |> get_session(:credential)
      |> StructTranslater.to_atom_struct()
    IO.puts inspect credential
    render(
      clean_session(conn),
      "credential.html",
      %{
        credential: credential
      })
  end

  def clean_session(conn) do
    conn
    |> fetch_session()
    # |> delete_session(:credential)
  end
end
