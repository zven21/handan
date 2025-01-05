defmodule HandanWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use HandanWeb, :controller` and
  `use HandanWeb, :live_view`.
  """
  use HandanWeb, :html

  embed_templates "layouts/*"
end
