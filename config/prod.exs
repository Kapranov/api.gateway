import Config

root_path = Path.expand("../config/", __DIR__)
file_path = "#{root_path}/prod.secret.exs"

if File.exists?(file_path) do
  import_config "prod.secret.exs"
else
  File.write(file_path, """
  import Config

  # For additional configuration outside of environmental variables
  """)
end
