import Config

root_path = Path.expand("../config/", __DIR__)
file_path = "#{root_path}/test.secret.exs"

case System.cmd "uname", [] do
  {"FreeBSD\n",0} -> nil
  {"Darwin\n", 0} -> nil
  {"Linux\n", 0} ->
    config :ex_unit_notifier,
      notifier: ExUnitNotifier.Notifiers.NotifySend
  _other -> nil
end

if System.get_env("CI") do
  config :junit_formatter,
  report_dir: "/tmp/test-results/exunit",
  report_file: "results.xml",
  print_report_file: true,
  prepend_project_name?: true
end

if File.exists?(file_path) do
  import_config "test.secret.exs"
else
  File.write(file_path, """
  import Config

  # For additional configuration outside of environmental variables
  """)
end
