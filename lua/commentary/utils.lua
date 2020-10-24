local M = {}

function string.debug(s)
  print(string.format("'%s'", s))
end

-- trim one space from front, back, or both
function string.trim1(s, front, back)
  if front then s = s:gsub("^%s", "") end
  if back then s = s:gsub("%s$", "") end
  return s
end

do
  local matches =
  {
    ["^"] = "%^";
    ["$"] = "%$";
    ["("] = "%(";
    [")"] = "%)";
    ["%"] = "%%";
    ["."] = "%.";
    ["["] = "%[";
    ["]"] = "%]";
    ["*"] = "%*";
    ["+"] = "%+";
    ["-"] = "%-";
    ["?"] = "%?";
    ["\0"] = "%z";
  }

  -- escape all patterns in lua string to be able to match literal string
  function string.escape_lua_pattern(s)
    return s:gsub(".", matches)
  end
end

-- add whitespace at the front, end, or both
function string.add_whitespace(str, front, back)
  if front then str = string.insert(str, " ", 0) end
  if back then str = string.insert(str, " ", str:len()) end
  return str
end

-- Insert str2 into str1 at index. 0 means prepend. 1 means insert after the first character (1 indexed).
-- Inserting equal to the lenght of the string means appending to the string
function string.insert(str1, str2, pos)
  local sub1 = string.sub(str1, 1, pos)
  local sub2 = string.sub(str1, pos + 1)
  return sub1 .. str2 .. sub2
end

-- wheather the comment is a surround comment (c style) comment or not (python style)
function M.is_surround_comment(commentstring)
  if commentstring:find(".+%%s.+") then return true else return false end
end

function M.get_comment_part(commentstring)
  if M.is_surround_comment(commentstring) then
    return commentstring:match("(.+)%%s(.+)")
  else
    return commentstring:match("(.+)%%s")
  end
end

-- comment string defined as
function M.comment(line, commentstring)
  if M.is_surround_comment(commentstring) then
    line = string.add_whitespace(line, true, true)
  else
    line = string.add_whitespace(line, true, false)
  end

  return string.format(commentstring, line)
end

function M.uncomment(line, commentstring)
  local cmnt1, cmnt2 = M.get_comment_part(commentstring)
  cmnt1 = string.escape_lua_pattern(cmnt1)
  if cmnt2 then cmnt2 = string.escape_lua_pattern(cmnt2) end

  local pattern
  if cmnt2 then
    local pattern1 = cmnt1 .. "%s?"
    local pattern2 = "%s?" .. cmnt2
    local full_pattern = pattern1 .. "(.*)" .. pattern2
    print('full pattern:')
    string.debug(full_pattern)
    line = line:gsub(full_pattern, "%1")
    print('line:')
    string.debug(line)
    return line
  else
    pattern = string.escape_lua_pattern(cmnt1) .. "%s?"
    line = line:gsub(pattern, "", 1)
  end
  return line
end

function M.should_comment(line, commentstring)
  local comment_part = commentstring:gsub("%%s", "")
  if line:match(comment_part) then
    return false
  else
    return true
  end
end

function M.toggle_comment(line, commentstring)
  if should_comment(line, commentstring) then
    return comment(line, commentstring)
  else
    return uncomment(line, commentstring)
  end
end

return M
