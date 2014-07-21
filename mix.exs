defmodule Mix.Tasks.Make do
  use Mix.Task

  @moduledoc """
  Runs Makefile in root directory of project. See the documentation
  in the Makefile for details.
  """
  
  @shortdoc """
  Runs Makefile in root directory of project.
  """
  
  @doc """
  Runs Makefile in root directory of project.
  """
  def run(_) do
      if Mix.shell.cmd("make") != 0 do
        Mix.raise "make command failed."
      end
  end
end

defmodule Ws.Mixfile do
  use Mix.Project

  def project do
    [ app: :ws,
      version: "0.0.1",
      elixir: "~> 0.14.2",
      name: "ws",
      source_url: "https://github.com/batwicket/ws",
      homepage_url: "https://github.com/batwicket",
      deps: deps ]
  end

  # Configuration for the OTP application
  def application do
    [
      mod: { Ws, [] },
      applications: [:phoenix]
    ]
  end

  # Returns the list of dependencies in the format:
  # { :foobar, git: "https://github.com/elixir-lang/foobar.git", tag: "0.1" }
  #
  # To specify particular versions, regardless of the tag, do:
  # { :barbat, "~> 0.1", github: "elixir-lang/barbat" }
  defp deps do
    [
      {:cowboy, "~> 0.10.0", github: "extend/cowboy", optional: true},
	  {:ex_doc, github: "elixir-lang/ex_doc"},
      {:jsex,     github: "talentdeficit/jsex"},
	  {:markdown, github: "devinus/markdown"},
      {:phoenix, "0.3.1"}
    ]
  end
end
