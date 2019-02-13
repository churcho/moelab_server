defmodule MoelabServer.Anime.Bangumi do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [type: :utc_datetime_usec]
  @required_fields ~w(aka audit_status bg_photo brief_summary casts countries current_season current_series directors episodes_count languages mainland_pubdate original_title photo pub_year rating recent_update_time refresh_tag rgb seasons_count state subtype summary thumbs title vo_id recent_update_time)a

  schema "bangumi" do
    field(:countries, :string)
    field(:rating, :float)
    field(:rgb, :string)
    field(:episodes_count, :integer)
    field(:bg_photo, :string)
    field(:refresh_tag, :string)
    field(:summary, :string)
    field(:subtype, :string)
    field(:recent_update_time, :utc_datetime)
    field(:original_title, :string)
    field(:directors, :string)
    field(:audit_status, :integer)
    field(:current_series, :float)
    field(:current_season, :integer)
    field(:title, :string)
    field(:aka, :string)
    field(:languages, :string)
    field(:pub_year, :string)
    field(:mainland_pubdate, :string)
    field(:state, :integer)
    field(:brief_summary, :string)
    field(:photo, :string)
    field(:seasons_count, :integer)
    field(:thumbs, {:array, :string})
    field(:casts, :string)
    field(:vo_id, :string)

    timestamps()
  end

  @doc false
  def changeset(bangumi, attrs) do
    bangumi
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
  end
end