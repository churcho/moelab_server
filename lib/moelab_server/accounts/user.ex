defmodule MoelabServer.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field(:email, :string, unique: true)
    field(:name, :string)
    field(:username, :string)
    field(:avatar, :string)
    field(:password_hash, :string)
    field(:password, :string, virtual: true)
    field(:password_confirmation, :string, virtual: true)
    field(:role, :string)

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :email, :password, :password_confirmation, :avatar, :role])
    |> validate_required([
      :name,
      :username,
      :email,
      :password,
      :password_confirmation,
      :avatar,
      :role
    ])
    |> validate_format(:email, ~r/@/)
    |> update_change(:email, &String.downcase(&1))
    |> validate_length(:password, min: 6, max: 100)
    |> validate_confirmation(:password)
    |> unique_constraint(:email)
    |> unique_constraint(:username)
    |> put_pass_hash()
  end

  defp put_pass_hash(changeset), do: changeset
end
