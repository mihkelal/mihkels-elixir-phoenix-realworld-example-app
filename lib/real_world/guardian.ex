defmodule RealWorld.Guardian do
  use Guardian, otp_app: :real_world

  alias RealWorld.{Repo, Account.User}

  def subject_for_token(%User{} = user, _claims) do
    {:ok, to_string(user.id)}
  end

  def subject_for_token(_, _), do: {:error, "Unknown resource type"}

  def resource_from_claims(%{"sub" => user_id}) do
    {:ok, Repo.get(User, user_id)}
  end

  def resource_from_claims(_claims), do: {:error, "Unknown resource type"}
end
