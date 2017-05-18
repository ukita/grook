defmodule Grook.Regexp do
  def username do
    ~r/\A^[^\.][a-zA-Z0-9_\.]*[^\.]$/
  end

  def email do
    ~r/(\w+)@([\w.]+)/
  end
end
