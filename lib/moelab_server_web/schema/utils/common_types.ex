defmodule MoelabServerWeb.Schema.Util.CommonTypes do
  use Absinthe.Schema.Notation

  @default_inner_page_size 5

  enum :bangumi_sort_enum do
    value(:hot)
    value(:new)
  end

  enum :sub_bangumi_sort_enum do
    value(:recent)
  end

  enum :user_sort_enum do
    value(:id)
    value(:username)
  end

  enum :comment_sort_enum do
    value(:asc_inserted)
    value(:desc_inserted)
    value(:most_likes)
    value(:most_dislikes)
  end

  enum(:viewer_did_type, do: value(:viewer_did))
  enum(:count_type, do: value(:count))
  enum(:bangumi_type, do: value(:bangumi))

  @desc "inline members-like filter for dataloader usage"
  input_object :members_filter do
    field(:first, :integer, default_value: @default_inner_page_size)
  end

  @desc """
  The `DateTime` scalar type represents a date and time in the UTC
  timezone. The DateTime appears in a JSON response as an ISO8601 formatted
  string, including UTC timezone ("Z"). The parsed date and time string will
  be converted to UTC and any UTC offset other than 0 will be rejected.
  """
  scalar :datetime, name: "DateTime" do
    serialize(&DateTime.to_iso8601/1)
    parse(&parse_datetime/1)
  end

  @spec parse_datetime(Absinthe.Blueprint.Input.String.t()) :: {:ok, DateTime.t()} | :error
  @spec parse_datetime(Absinthe.Blueprint.Input.Null.t()) :: {:ok, nil}
  defp parse_datetime(%Absinthe.Blueprint.Input.String{value: value}) do
    case DateTime.from_iso8601(value) do
      {:ok, datetime, 0} -> {:ok, datetime}
      {:ok, _datetime, _offset} -> :error
      _error -> :error
    end
  end

  defp parse_datetime(%Absinthe.Blueprint.Input.Null{}) do
    {:ok, nil}
  end

  defp parse_datetime(_) do
    :error
  end
end
