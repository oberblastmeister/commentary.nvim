require 'busted.runner'()

local utils = require("utils")

describe("#string", function()
  it("escape lua pattern", function()
    assert.are.equals(string.escape_lua_pattern("/*"), "/%*")
    assert.are.equals(string.escape_lua_pattern("**/"), "%*%*/")
    assert.are.equals(string.escape_lua_pattern("?hello*[hello]"), "%?hello%*%[hello%]")
  end)
end)

describe("#insert", function()
  it("simple", function()
    assert.are.equals(string.insert("hello", " dude ", 2), "he dude llo")
  end)

  it("beginning", function()
    assert.are.equals(string.insert("person", "wow ", 0), "wow person")
  end)

  it("one", function()
    assert.are.equals(string.insert("person", " wow ", 1), "p wow erson")
  end)

  it("end", function()
    local s = "person"
    assert.are.equals(string.insert(s, " wow", s:len()), "person wow")
  end)

  it("whitespace", function()
    assert.are.equals(string.insert("hi", " ", 0), " hi")
  end)

  it("whitespace end", function()
    assert.are.equals(string.insert("hi", " ", 0), " hi")
  end)
end)

describe("#white space", function()
  it("add back", function()
    assert.are.equals(string.add_whitespace("hi", true, false), " hi")
  end)

  it("add front", function()
    assert.are.equals(string.add_whitespace("hi", false, true), "hi ")
  end)

  it("add front", function()
    assert.are.equals(string.add_whitespace("hi", true, true), " hi ")
  end)

  it("trim whitespace front", function()
    assert.are.equals(string.trim1("  hi", true, false), " hi")
  end)

  it("trim whitespace back", function()
    assert.are.equals(string.trim1(" hi ", false, true), " hi")
  end)

  it("trim whitespace both", function()
    assert.are.equals(string.trim1(" hi  ", true, true), "hi ")
  end)
end)

describe("#comment type", function()
  it("c", function()
    assert.is_true(utils.is_surround_comment("/*%s*/"))
  end)

  it("python", function()
    assert.is_not_true(utils.is_surround_comment("#%s"))
  end)

  it("rust", function()
    assert.is_not_true(utils.is_surround_comment("//%s"))
  end)
end)

describe("#comment", function()
  it("c", function()
    assert.are.equals(utils.comment("this is a line", "/*%s*/"), "/* this is a line */")
  end)

  it("rust", function()
    assert.are.equals(utils.comment("another line", "//%s"), "// another line")
  end)

  it("python", function()
    assert.are.equals(utils.comment("python code", "#%s"), "# python code")
  end)

  it("leading whitespace c", function()
    assert.are.equals(utils.comment(" leading whitespace", "/*%s*/"), "/*  leading whitespace */")
  end)
end)

describe("#uncomment", function()
  it("c", function()
    assert.are.equals(utils.uncomment("/* commented */", "/*%s*/"), "commented")
    assert.are.equals(utils.uncomment("/* this is commented */", "/*%s*/"), "this is commented")
    assert.are.equals(utils.uncomment("/*/* this is commented */", "/*%s*/"), "/* this is commented")
    assert.are.equals(utils.uncomment("/*/* this is commented */*/", "/*%s*/"), "/* this is commented */")
    assert.are.equals(utils.uncomment("this is commented */*/", "/*%s*/"), "this is commented */*/")
  end)

  it("python", function()
    assert.are.equals(utils.uncomment("# this is commented", "#%s"), "this is commented")
  end)

  it("multiple comments", function()
    assert.are.equals(utils.uncomment("# /* this is commented */", "#%s"), "/* this is commented */")
  end)
end)
