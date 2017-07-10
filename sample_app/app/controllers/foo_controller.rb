class FooController < ApplicationController
  def bar
    render html: "bar"
  end

  def baz
    render html: "baz
  end
end
