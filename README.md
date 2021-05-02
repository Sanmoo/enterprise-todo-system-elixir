# SimpleTodo

Umbrella elixir application for an "Enterprise" TODO system.
This is my take on following [clean architecture](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html) patterns for medium to large sized enterprise grade systems in Elxir. It is obviously overengineering for a simple TODO system like this one.

## composing apps
* simple_todo_core: This holds all the code and tests for our entities and use cases. It also exposes repository behaviours that "consumer" components should provide implementations for. Does not depend on any other component/app in the umbrella.
* simple_todo_cli: Still under development. This is our SimpleTodo app delivered as a CLI program. This component has a subcomponent in it that implements the repositories behaviours using the file system.
* simple_todo_web: Still under development. This is our SimpleTodo app delivered as web system, using Phoenix framework. This component has a subcomponent in it that implements the repositories behaviours using Ecto and Postgres.

