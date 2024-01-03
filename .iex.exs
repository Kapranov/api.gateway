import_if_available(Ecto.Query)
import_if_available(Ecto.Changeset)

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
eval_info = [:yellow, :bright]
eval_warning = [:yellow, :bright, "🧪\n"]


timestamp = fn ->
  {_date, {hour, minute, _second}} = :calendar.local_time
  [hour, minute]
  |> Enum.map(&(String.pad_leading(Integer.to_string(&1), 2, "0")))
  |> Enum.join(":")
end

IEx.configure(
  inspect: [
    pretty: true,
    limit: inspect_limit,
    width: 80
  ],
  width: 80,
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
  alive_prompt: alive_prompt,
  default_prompt: [ :light_magenta, "⚡", ">", :white, :reset ] |> IO.ANSI.format() |> IO.chardata_to_string()
  #default_prompt: "#{IO.ANSI.green}%prefix#{IO.ANSI.reset} " <> "[#{IO.ANSI.magenta}#{timestamp.()}#{IO.ANSI.reset} " <> ":: #{IO.ANSI.cyan}%counter#{IO.ANSI.reset}]"
)

# `Process.sleep` doesn't sleep long enough
# There's an event in the future, and in the original livebook,
# I use `Process.sleep` to wait until the event starts to start
# sending graphql requests.
#
# Since the sleep is short, the first graphql request lands slightly
# before the event starts and it messes up the flow.
#
# I tried to isolate the problem, and here's a simpler cell that
# exhibits the same behavior.
#
# - check now
# - sleep for 10s
# - check now, again
# - it shouldn't be before `now + 10s`
#

now = DateTime.utc_now()
t10 = DateTime.add(now, 20, :second)
expected_diff = DateTime.diff(t10, now, :millisecond)
[now: now, t10: t10, expected_diff: expected_diff] |> IO.inspect()

Process.sleep(expected_diff)

woke_at = DateTime.utc_now()
actual_diff = DateTime.diff(woke_at, now, :millisecond)

[woke_at: woke_at, actual_diff: actual_diff] |> IO.inspect()

:ok

clear()
