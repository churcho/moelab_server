defmodule MoelabServerWeb.Schema.Account.AccountQueries do
  use Absinthe.Schema.Notation

  alias MoelabServerWeb.Resolvers
  alias MoelabServerWeb.Schema.Middleware

  object :account_queries do
    @desc "Get a list of all users"
    field :users, list_of(:user) do
      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.AccountsResolver.users/3)
    end

    @desc "Get a list of subscribed bangumi"
    field :subscribed_bangumi, :paged_bangumi do
      arg(:user_id, :id)
      arg(:filter, non_null(:paged_filter))

      middleware(Middleware.Authorize, :any)
      resolve(&Resolvers.AccountsResolver.subscribed_bangumi/3)
    end
  end
end
