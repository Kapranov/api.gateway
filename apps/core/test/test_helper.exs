os_exclude = if :os.type() == {:unix, :darwin},
  do: [skip_on_mac: true], else: []

{:ok, _} = Application.ensure_all_started(:ex_machina)

ExUnit.configure(exclude: [pending: true],
  formatters: [JUnitFormatter, ExUnit.CLIFormatter, ExUnitNotifier])
ExUnit.start(exclude: [:skip | os_exclude], trace: true)

Faker.start()

Ecto.Adapters.SQL.Sandbox.mode(Core.Repo, :manual)

Application.put_env(:ex_unit, :after_suite, [])
Process.register(self(), :after_suite_test_process)

unless Version.compare(System.version(), "1.8.0") == :lt do
  ExUnit.after_suite(fn _ ->
    send(:after_suite_test_process, :first_after_suite)
  end)
  ExUnit.after_suite(fn result ->
    send(:after_suite_test_process, result)
  end)
  ExUnit.after_suite(fn _ ->
    send(:after_suite_test_process, :third_after_suite)
  end)
end
