defmodule SuperIssuerWeb.UserController do
  use SuperIssuerWeb, :controller
  alias SuperIssuer.User

  def new(conn, _params) do
    changeset = User.change_user(%User{})
    render(conn, "sign_up.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    case User.create_user(user_params) do
      {:ok, _user} ->
        conn
        |> put_flash(:info, "Signed up successfully.")
        |> redirect(to: Routes.page_path(conn, :index))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "sign_up.html", changeset: changeset)
    end
  end

  def index(conn, _) do
    if get_session(conn, :current_user_id) do
      render(conn, "user.html", payload: %{login?: true})
    else
      render(conn, "user.html", payload: %{login?: false})
    end
  end
end
