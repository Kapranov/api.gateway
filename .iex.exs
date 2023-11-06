Application.put_env(:elixir, :ansi_enabled, true)

IO.puts IO.ANSI.magenta()
        <> IO.ANSI.color_background(1, 0, 1)
        <> IO.ANSI.bright()
        <> IO.ANSI.underline()
        <> IO.ANSI.blink_slow()
        <> IO.ANSI.reset()

queue_length = fn ->
  self()
  |> Process.info()
  |> Keyword.get(:message_queue_len)
end

prefix = IO.ANSI.light_black_background() <> IO.ANSI.magenta() <> "%prefix" <> IO.ANSI.reset()
counter = IO.ANSI.light_black_background() <> IO.ANSI.black() <> "-%node-(%counter)" <> IO.ANSI.reset()
info = IO.ANSI.light_blue() <> "✉ #{queue_length.()}" <> IO.ANSI.reset()
last = IO.ANSI.yellow() <> "➤➤➤" <> IO.ANSI.reset()
alive = IO.ANSI.bright() <> IO.ANSI.yellow() <> IO.ANSI.blink_rapid() <> "⚡" <> IO.ANSI.reset()

default_prompt = prefix <> counter <> " | " <> info <> " | " <> last
alive_prompt = prefix <> counter <> " | " <> info <> " | " <> alive <> last

inspect_limit = 150
history_size = 1_000_000_000

eval_result = [:green, :bright]
eval_error = [:red, :bright]
eval_info = [:blue, :bright]

IEx.configure [
  inspect: [limit: inspect_limit],
  history_size: history_size,
  colors: [
    eval_result: eval_result,
    eval_error: eval_error,
    eval_info: eval_info,
    syntax_colors: [
      number: :light_yellow,
      atom: :light_cyan,
      string: :light_black,
      boolean: [:light_blue],
      nil: [:magenta, :bright]
    ],
    ls_directory: :cyan,
    ls_device: :yellow,
    doc_code: :green,
    doc_inline_code: :magenta,
    doc_headings: [:cyan, :underline],
    doc_title: [:cyan, :bright, :underline]
  ],
  default_prompt: ["\e[G", :light_magenta, "⚡ iex", ">", :white, :reset] |> IO.ANSI.format() |> IO.chardata_to_string(),
  alive_prompt: alive_prompt
]
