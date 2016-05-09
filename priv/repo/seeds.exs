# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Insights.Repo.insert!(%Insights.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.
#

alias Insights.Repo
alias Insights.User
alias Insights.Insight

import Ecto.Query

users = [
  %{
    first_name: "Jimmy",
    last_name: "Farrell",
    username: "jimmyfarrell",
    email: "jfarrell22@gmail.com",
    password: "password"
  },
  %{
    first_name: "David",
    last_name: "Mitchell",
    username: "cloudatlas",
    email: "dmitchell@example.com",
    password: "password"
  },
  %{
    first_name: "Zadie",
    last_name: "Smith",
    username: "onbeauty",
    email: "zsmith@example.com",
    password: "password"
  },
  %{
    first_name: "Hermann",
    last_name: "Hesse",
    username: "siddhartha",
    email: "hhesse@example.com",
    password: "password"
  }
]

Insight |> Repo.delete_all
User |> Repo.delete_all

users |> Enum.each(fn(user_params) ->
  User.registration_changeset(%User{}, user_params) |> Repo.insert!
end)

insights = [
  %{
    title: "First Insight",
    body: "# Intro
Go ahead, play around with the editor! Be sure to check out **bold** and *italic* styling, or even [links](http://google.com). You can type the Markdown syntax, use the toolbar, or use shortcuts like `cmd-b` or `ctrl-b`.

## Lists
Unordered lists can be started using the toolbar or by typing `* `, `- `, or `+ `. Ordered lists can be started by typing `1. `.

#### Unordered
* Lists are a piece of cake
* They even auto continue as you type
* A double enter will end them
* Tabs and shift-tabs work too

#### Ordered
1. Numbered lists...
2. ...work too!

## What about images?
![Yes](http://i.imgur.com/sZlktY7.png)",
    author_username: "jimmyfarrell"
  },
  %{
    title: "Slade House",
    body: "Some words about **Slade House**...",
    author_username: "cloudatlas"
  },
  %{
    title: "White Teeth",
    body: "Some words about **White Teeth**...",
    author_username: "onbeauty"
  },
  %{
    title: "Narcissus & Goldmund",
    body: "Some words about **Narcissus & Goldmund**...",
    author_username: "siddhartha"
  }
]

insights |> Enum.each(fn(insight_params) ->
  author = User |> where(username: ^insight_params.author_username) |> Repo.one
  new_params =
    insight_params
    |> Map.delete(:author_username)
    |> Map.put(:author_id, author.id)
  Insight.changeset(%Insight{}, new_params) |> Repo.insert!
end)
