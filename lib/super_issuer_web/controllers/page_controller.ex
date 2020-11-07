defmodule SuperIssuerWeb.PageController do
  use SuperIssuerWeb, :controller
  alias SuperIssuer.CredentialVerifier, as: CredentialVerifier
  alias SuperIssuer.WeidAdapter, as: WeidAdapter

  @payload %{
    name: "人人发证",
    slogan: "人人都能构建自己的数字凭证系统",
    credetialverifier: %CredentialVerifier{},
    changeset: nil,
    verify_result: nil
  }

  @doc """
    post action
  """

  def index(
        conn,
        %{
          "credential_verifier" => %{
            # "pubkey" => pubkey,
            "file" => %Plug.Upload{
              filename: _f_name,
              path: path
            }
          }
        }
      ) do
    credential =
      path
      |> File.read!()
      |> Poison.decode!()

    {_result, msg} = WeidAdapter.verify_credential(System.get_env("weid_node"), credential)

    conn
    |> put_flash(:info, handle_msg(msg))
    |> render("index.html", payload: create_payload())
  end

  @doc """
    get action.
  """
  def index(conn, _params) do
    render(conn, "index.html", payload: create_payload())
  end

  def handle_msg(true), do: "证书合法！"

  def handle_msg(other), do: "证书非法！原因：#{other}"

  def create_payload() do
    changeset = Ecto.Changeset.change(%CredentialVerifier{})
    %{@payload | changeset: changeset}
  end
end
