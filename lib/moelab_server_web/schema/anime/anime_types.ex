defmodule MoelabServerWeb.Schema.Anime.AnimeTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers
  import MoelabServerWeb.Schema.Utils.Helper
  alias MoelabServer.Anime
  alias MoelabServerWeb.Schema.Middleware

  @desc "Filtering options for the bangumi list"
  input_object :bangumi_filter do
    pagination_args()

    @desc "Sort"
    field(:sort, :bangumi_sort_enum)

    @desc "Matching a title"
    field(:title, :string)

    @desc "Matching a country"
    field(:country, :string)

    @desc "Matching a state"
    field(:state, :integer)

    @desc "Matching a year"
    field(:year, :string)

    @desc "Matching a week"
    field(:week, :string)

    @desc "Matching a genre name"
    field(:genre, :string)

    @desc "Matching a tag"
    field(:tag, :string)
  end

  object :paged_bangumi do
    field(:entries, list_of(:bangumi))
    pagination_fields()
  end

  object :bangumi do
    bangumi_args()
    field(:creater, :user, resolve: dataloader(Anime))
    field(:genres, list_of(:genre), resolve: dataloader(Anime))
    field(:tags, list_of(:tag), resolve: dataloader(Anime))

    field :comments, list_of(:comment) do
      arg(:filter, :members_filter)

      resolve(dataloader(Anime))
    end

    field :viewer_has_subscribed, :boolean do
      arg(:viewer_did, :viewer_did_type, default_value: :viewer_did)

      middleware(Middleware.PutCurrentUser)
      resolve(dataloader(Anime, :subscribers))
      middleware(Middleware.ViewerDidConvert)
    end

    field :subscribers, list_of(:user) do
      arg(:filter, :members_filter)
      resolve(dataloader(Anime))
    end

    field :subscribers_count, :integer do
      arg(:count, :count_type, default_value: :count)
      arg(:type, :bangumi_type, default_value: :bangumi)
      resolve(dataloader(Anime, :subscribers))
      middleware(Middleware.ConvertToInt)
    end
  end

  input_object :bangumi_input do
    bangumi_args()
  end

  input_object :comments_filter do
    pagination_args()
    field(:sort, :comment_sort_enum, default_value: :asc_inserted)
  end

  object :comment do
    comments_fields()
  end

  object :bangumi_comment do
    comments_fields()
    field(:bangumi, :bangumi, resolve: dataloader(Anime))
  end

  object :paged_comments do
    field(:entries, list_of(:comment))
    pagination_fields()
  end

  object :paged_bangumi_comments do
    field(:entries, list_of(:bangumi_comment))
    pagination_fields()
  end

  object :genre do
    field(:name, :string)
  end

  object :tag do
    field(:name, :string)
  end

  object :bangumi_tag do
    field(:bangumi, :bangumi, resolve: dataloader(Anime))
    field(:tag, :tag, resolve: dataloader(Anime))
  end

  object :bangumi_genre do
    field(:bangumi, :bangumi, resolve: dataloader(Anime))
    field(:genre, :genre, resolve: dataloader(Anime))
  end
end
