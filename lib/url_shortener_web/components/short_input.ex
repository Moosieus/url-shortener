defmodule UrlShortenerWeb.ShortInput do
  use Phoenix.Component
  import UrlShortenerWeb.CoreComponents, only: [translate_error: 1, label: 1, error: 1]

  @doc """
  Copy of the default input Core Component with some custom styling.
  """
  attr :id, :any, default: nil
  attr :name, :any
  attr :label, :string, default: nil
  attr :value, :any

  attr :type, :string,
    default: "text",
    values: ~w(checkbox color date datetime-local email file hidden month number password
               range radio search select tel text textarea time url week)

  attr :field, Phoenix.HTML.FormField,
    doc: "a form field struct retrieved from the form, for example: @form[:email]"

  attr :errors, :list, default: []
  attr :checked, :boolean, doc: "the checked flag for checkbox inputs"
  attr :prompt, :string, default: nil, doc: "the prompt for select inputs"
  attr :options, :list, doc: "the options to pass to Phoenix.HTML.Form.options_for_select/2"
  attr :multiple, :boolean, default: false, doc: "the multiple flag for select inputs"

  attr :rest, :global,
    include: ~w(accept autocomplete capture cols disabled form list max maxlength min minlength
                multiple pattern placeholder readonly required rows size step)

  slot :inner_block

  def short_input(%{field: %Phoenix.HTML.FormField{} = field} = assigns) do
    assigns
    |> assign(field: nil, id: assigns.id || field.id)
    |> assign(:errors, Enum.map(field.errors, &translate_error(&1)))
    |> assign_new(:name, fn -> if assigns.multiple, do: field.name <> "[]", else: field.name end)
    |> assign_new(:value, fn -> field.value end)
    |> short_input()
  end

  # All other inputs text, datetime-local, url, password, etc. are handled here...
  def short_input(assigns) do
    ~H"""
    <div phx-feedback-for={@name}>
      <.label for={@id}><%= @label %></.label>
      <div class={[
        "flex bg-white text-black rounded-md px-3 py-2 mt-2",
        @errors == [] && "border-zinc-300 focus:border-zinc-400",
        @errors != [] && "border-rose-400 focus:border-rose-400"
      ]}>
        <span><%= UrlShortenerWeb.Endpoint.host() %>/</span>
        <input
          type={@type}
          name={@name}
          id={@id}
          value={Phoenix.HTML.Form.normalize_value(@type, @value)}
          {@rest}
          placeholder="short-name-here"
          class="flex-grow bg-transparent border-none p-0 m-0"
        />
      </div>
      <.error :for={msg <- @errors}><%= msg %></.error>
    </div>
    """
  end
end
