ExUnit.start

Mix.Task.run "ecto.create", ~w(-r Insights.Repo --quiet)
Mix.Task.run "ecto.migrate", ~w(-r Insights.Repo --quiet)
Ecto.Adapters.SQL.begin_test_transaction(Insights.Repo)

