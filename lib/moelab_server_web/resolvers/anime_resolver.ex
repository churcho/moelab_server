defmodule MoelabServerWeb.Resolvers.AnimeResolver do
  import ShortMaps
  alias MoelabServer.Anime
  alias MoelabServer.Anime.{Bangumi, BangumiComment}
  alias Helper.ORM

  def bangumi(_, ~m(id)a, _), do: ORM.find(Bangumi, id)

  def all_bangumi(_, ~m(filter)a, _), do: Anime.list_bangumi(filter)

  def all_bangumi(_, _, _), do: Anime.list_bangumi(%{page: 1, size: 10})

  def create_bangumi(_, %{input: input}, %{context: %{current_user: current_user}}) do
    bangumi_input = Map.merge(input, %{creater_id: current_user.id})
    Bangumi |> ORM.create(bangumi_input)
  end

  def update_bangumi(_, ~m(id input)a, %{context: %{current_user: current_user}}) do
    bangumi_input = Map.merge(input, %{creater_id: current_user.id})
    Bangumi |> ORM.find_update(id, bangumi_input)
  end

  def update_bangumi(_, %{input: input}, %{context: %{current_user: current_user}}) do
    bangumi_input = Map.merge(input, %{creater_id: current_user.id})
    Bangumi |> ORM.find_update(bangumi_input)
  end

  def delete_bangumi(_, ~m(id)a, _), do: Bangumi |> ORM.find_delete(id)

  def subscribe_bangumi(_, ~m(id)a, %{context: %{current_user: current_user}}) do
    Anime.subscribe_bangumi(%Bangumi{id: id}, current_user)
  end

  def unsubscribe_bangumi(_, ~m(id)a, %{context: %{current_user: current_user}}) do
    Anime.unsubscribe_bangumi(%Bangumi{id: id}, current_user)
  end

  def bangumi_subscribers(_, ~m(id filter)a, _) do
    Anime.bangumi_subscribers(%Bangumi{id: id}, filter)
  end

  def bangumi_subscribers(_, _, _), do: {:error, "invalid args"}

  def create_tag(_, %{bangumi_id: bid, name: tag_name}, _) do
    Anime.create_tag(bid, tag_name)
  end

  def create_genre(_, %{bangumi_id: bid, name: genre_name}, _) do
    Anime.create_genre(bid, genre_name)
  end

  def create_comment(_, input, %{context: %{current_user: current_user}}) do
    comment_input = Map.merge(input, %{author_id: current_user.id})
    ORM.create(BangumiComment, comment_input)
  end

  def update_comment(_, ~m(id body)a, %{context: %{current_user: current_user}}) do
    with {:ok, content} <- ORM.find(BangumiComment, id),
         true <- content.author_id == current_user.id do
      BangumiComment |> ORM.find_update(~m(id body)a)
    end
  end

  def delete_comment(_, ~m(id)a, %{context: %{current_user: current_user}}) do
    with {:ok, content} <- ORM.find(BangumiComment, id),
         true <- content.author_id == current_user.id do
      BangumiComment |> ORM.find_delete(id)
    end
  end

  def paged_comments(_, ~m(id filter)a, _) do
    Anime.list_comments(id, filter)
  end

  def paged_comments(_, _, _), do: {:error, "invalid args"}
end
