os_exclude = if :os.type() == {:unix, :darwin},
  do: [skip_on_mac: true], else: []

ExUnit.configure(exclude: [pending: true],
  formatters: [JUnitFormatter, ExUnit.CLIFormatter, ExUnitNotifier])
ExUnit.start(exclude: [:skip | os_exclude], trace: true)
