local M = {}

function M.insert(str1, str2, pos)
    local sub1 = string.sub(str1, 1, pos)
    local sub2 = string.sub(str1, pos + 1)
    return sub1 .. str2 .. sub2
end

function M.add_white_space(str, ...)
  local opts = {...}
  if opts[0] then
    str = insert(str, " ", 0)
  end
  if opts[1] then
    str =  insert(str, " ", str:len())
  end
  return str
end

-- comment string defined as 
function M.comment(line, commentstring)
  if string.match(commentstring, ".+%%s.+") then
    line = add_white_space(line, true, true)
  else
    line = add_white_space(line, true)
  end

  return string.format(commentstring, line)
end

function M.uncomment(line, commentstring)
  local comment_part = commentstring:gsub("%%s", "")
  line:gsub(comment_part .. "%s*", "")
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
