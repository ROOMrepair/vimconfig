--! stolen from
--? https://github.com/folke/todo-comments.nvim/blob/main/lua/todo-comments/highlight.lua

local M = {}
local Cstyle = {
  line = "//",
  block = { "/\\*", "\\*/" },
}
local hlGroup = {
  ["!"] = "attention",
  ["?"] = "question",
  ["&"] = "andmark",
  ["#"] = "sharp",
}

M.tsp = require("nvim-treesitter.parsers")
M.ns = vim.api.nvim_create_namespace("comment_sign")
M.bufs = {}
M.wins = {}
M.state = {}
M.config = {
  throttle = 200,
  max_line_len = 400,
}

M.checkBlock = {}
M.commentBlockList = {}
M.commentInBlockList = {}
M.commentSign = {
  c = Cstyle,
  cpp = Cstyle,
  java = Cstyle,
  javascript = Cstyle,
  typescript = Cstyle,
  rust = Cstyle,
  jsonc = Cstyle,
  python = {
    line = "#",
  },
  lua = {
    line = "--",
    block = { "--\\[\\[", "\\]\\]" },
  },
  sh = {
    line = "#",
  },
  html = {
    block = { "\\<!--", "--\\>" },
  },
  xml = {
    block = { "\\<!--", "--\\>" },
  },
  css = {
    block = { "/\\*", "\\*/" },
  },
}
M.patterns = { "*.c", "*.cpp", "*.h", "*.hpp", "*.java", "*.lua", "*.py", "*.js", "*.ts", "*.sh", "*.html", "*.css" }
M.inBlockSign = "\\v ([!#&?]{2})"

function M.addHlGroup()
  vim.api.nvim_set_hl(M.ns, hlGroup["!"], {
    fg = "#8c2659",
  })

  vim.api.nvim_set_hl(M.ns, hlGroup["?"], {
    fg = "#4556d6",
  })

  vim.api.nvim_set_hl(M.ns, hlGroup["&"], {
    fg = "#1b7544",
  })

  vim.api.nvim_set_hl(M.ns, hlGroup["#"], {
    fg = "#9e6324",
  })
end

function M.buildCommentRegex(buf)
  local lang = M.tsp.get_buf_lang(buf)
  if not M.commentSign[lang] then
    return nil
  end
  local regexes = {}
  local lcomm = M.commentSign[lang].line
  local block = M.commentSign[lang].block
  local bcomm1 = block and block[1] or nil
  local bcomm2 = block and block[2] or nil
  if lcomm then
    local lre = "\\v" .. lcomm .. "([?#!&])"
    regexes.line = lre
  end

  if bcomm1 then
    local bre = "\\v" .. bcomm1 .. "([?#!&])"
    local bre2 = "\\v" .. bcomm2
    regexes.block = { bre, bre2 }
  end

  return regexes
end

function M.is_float(win)
  local opts = vim.api.nvim_win_get_config(win)
  return opts and opts.relative and opts.relative ~= ""
end

function M.is_valid_buf(buf)
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = buf })

  if buftype ~= "" and buftype ~= "quickfix" then
    return false
  end

  return true
end

function M.is_valid_win(win)
  if not vim.api.nvim_win_is_valid(win) then
    return false
  end
  -- avoid E5108 after pressing q:
  if vim.fn.getcmdwintype() ~= "" then
    return false
  end
  -- dont do anything for floating windows
  if M.is_float(win) then
    return false
  end
  local buf = vim.api.nvim_win_get_buf(win)
  return M.is_valid_buf(buf)
end

function M.is_quickfix(buf)
  return vim.api.nvim_get_option_value("buftype", { buf = buf }) == "quickfix"
end

local function get_comment_range(buf, row, col)
  local node = vim.treesitter.get_node({ bufnr = buf, pos = { row, col } })
  if not node then
    return
  end
  if node:type() == "comment" then
    local sr, sc, er, ec = node:range()
    return sr, sc, er, ec
  end
  local parent = node:parent()
  if parent and parent:type() then
    local sr, sc, er, ec = node:range()
    return sr, sc, er, ec
  end
end

function M.is_comment(buf, row, col) -- col row 都是 0 index
  if vim.treesitter.highlighter.active[buf] then
    local captures = vim.treesitter.get_captures_at_pos(buf, row, col)
    for _, c in ipairs(captures) do
      if c.capture == "comment" then
        return true
      end
    end
    return false
  else
    return false
  end
end

function M.match(str, patterns, start_from)
  if #str > M.config.max_line_len then
    return
  end
  start_from = start_from or 0
  local tmp_start = M.config.max_line_len
  local tmp_match = ""
  local tmp_matchReg = ""
  local tmp_type = ""
  for tp, pattern in pairs(patterns) do
    local pat
    if type(pattern) == "table" then
      pat = pattern[1]
    else
      pat = pattern
    end
    local m = vim.fn.matchlist(str, pat, start_from) -- 0based
    if #m > 1 and m[2] then
      local start = str:find(m[1], start_from + 1, true) -- 1based
      if start < tmp_start then
        tmp_start = start
        tmp_matchReg = m[1]
        tmp_match = m[2]
        tmp_type = tp
      end
    end
  end
  if tmp_start < M.config.max_line_len then
    return tmp_type, tmp_start, tmp_start + #tmp_matchReg, tmp_match -- 1based
  end
end

function M.matchInBlockLine(str, start_from)
  local m = vim.fn.matchlist(str, M.inBlockSign, start_from)
  if #m > 1 and m[2] then
    local matchSign = string.sub(m[2], 0, 1)
    local start = str:find(m[1], start_from + 1, true) -- 1based
    local finish = start + #m[1]
    return start, finish, matchSign
  end
end

---@param l { line:number,col:number}
---@param r { line:number,col:number}
---@param pos table
function M.pushcommentBlockList(pos, buf, msign, l, r)
  assert(l[1] < r[1] or (l[1] == r[1] and l[2] < r[2]))
  if not pos then
    return
  end

  if not pos[buf] then
    pos[buf] = {}
  end

  table.insert(pos[buf], { msign, l, r })
end

function M.add_highlights(buf)
  vim.api.nvim_set_hl_ns(M.ns)
  local cbuf = M.commentBlockList[buf]
  local cibuf = M.commentInBlockList[buf]
  if cbuf then
    for _, block in pairs(cbuf) do
      local hlg = hlGroup[block[1]] or "Comment"
      vim.hl.range(buf, M.ns, hlg, block[2], block[3])
    end
  end

  if cibuf then
    for _, block in pairs(cibuf) do
      local hlg = hlGroup[block[1]] or "Comment"
      vim.hl.range(buf, M.ns, hlg, block[2], block[3])
    end
  end

  M.commentBlockList[buf] = {}
  M.commentInBlockList[buf] = {}
end

--!! 不处理嵌套注释
function M.highlight(buf, first, last)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local regexes = M.buildCommentRegex(buf)
  if not regexes or (not regexes.line and not regexes.block) then
    return
  end

  local check_multiline = false
  local tmp_regex = regexes
  local l, r
  local inBlockL, inBlockR
  local msign, inblockSign

  local lines = vim.api.nvim_buf_get_lines(buf, first, last + 1, false)
  for i, line in ipairs(lines) do
    local offset = 0
    local line_width = #line
    local lnum = first + i - 1

    while offset < line_width do
      local substr = line:sub(offset + 1) -- sub 1based
      if substr == "" then
        break
      end
      local ok, tp, start, finish, match_sign = pcall(M.match, line, tmp_regex, offset)
      if not ok or not start or not finish then
        --  这个分支在check_multiline 时,一定是在 block 内的位置，即不和comment block 开头结尾的标志在同一行,匹配到则不会进入这个if block
        if check_multiline then -- 此时一定处于 block comment 内吗?? 如果没有匹配到即 not ok 则说明没有闭合,则说明还在内部??
          local iBStart, _, iBSign = M.matchInBlockLine(line, 0)
          if iBStart then
            inBlockL = { lnum, iBStart } -- 跳过空格
            inBlockR = { lnum, line_width }
            inblockSign = iBSign
            M.pushcommentBlockList(M.commentInBlockList, buf, inblockSign, inBlockL, inBlockR)
          end
        end
        break
      end

      if not M.is_comment(buf, lnum, start - 1) then
        break
      end

      if not check_multiline then
        if tp == "line" and match_sign then
          l = { lnum, start - 1 }
          r = { lnum, line_width } -- exclusive end
          msign = match_sign
          M.pushcommentBlockList(M.commentBlockList, buf, msign, l, r)
          break
        end
        if tp == "block" and match_sign then
          check_multiline = true
          tmp_regex = { block = regexes.block[2] }
          offset = finish - 1
          l = { lnum, start - 1 }
          msign = match_sign
        end
      else
        -- tp == "line" 不会有这个分支
        if tp == "block" then -- match_sign == regexed.block[2] start finish 1based
          check_multiline = false
          -- isCatch = true
          tmp_regex = regexes
          offset = finish - 1
          r = { lnum, finish - 1 }
          M.pushcommentBlockList(M.commentBlockList, buf, msign, l, r)
        end
      end
    end
  end
end

function M.Myredraw(buf, first, last, sign)
  first = math.max(first, 0)
  last = math.min(last, vim.api.nvim_buf_line_count(buf) - 1)
  if not M.checkBlock[buf] then
    M.checkBlock[buf] = {}
  end

  for i = first, last do
    M.checkBlock[buf][i] = true
  end
  if not M.timer then
    M.timer = vim.defer_fn(M.Myupdate, M.config.throttle)
  end
end

--- @return number?,number? # ExpandBlock (number,number) or nil
function M.matchExpandBlock(buf, first, last)
  if not vim.api.nvim_buf_is_valid(buf) then
    return
  end

  local regexes = M.buildCommentRegex(buf)
  if not regexes or not regexes.block then
    return
  end

  local headerLineNum = first
  local tailLineNum = last
  repeat
    local sr, _, _, _ = get_comment_range(buf, headerLineNum, 0)
    if not sr then
      break
    end
    if headerLineNum == sr then
      break
    else
      headerLineNum = sr
    end
  until false

  repeat
    local tail = vim.api.nvim_buf_get_lines(buf, tailLineNum, tailLineNum + 1, false)[1]
    local tailLen
    if tail then
      tailLen = math.max(#tail - 1, 0)
    else
      tailLen = 0
    end

    local _, _, er, _ = get_comment_range(buf, tailLineNum, tailLen)
    if not er then
      break
    end
    if tailLineNum == er then
      break
    else
      tailLineNum = er
    end
  until false

  return headerLineNum, tailLineNum
end

function M.Myupdate()
  if M.timer then
    M.timer:stop()
  end
  M.timer = nil
  for buf, bufstate in pairs(M.checkBlock) do
    if vim.api.nvim_buf_is_valid(buf) then
      if not vim.tbl_isempty(bufstate) then
        local dirty_lines = vim.tbl_keys(bufstate)
        table.sort(dirty_lines)
        local i = 1
        while i <= #dirty_lines do
          local first = dirty_lines[i]
          local last = dirty_lines[i]
          while dirty_lines[i + 1] == dirty_lines[i] + 1 do
            i = i + 1
            last = dirty_lines[i]
          end

          local expandedFirst, expandedLast = M.matchExpandBlock(buf, first, last)
          if not expandedFirst or not expandedLast then
            expandedFirst = first
            expandedLast = last
          end

          local ok = pcall(vim.api.nvim_buf_clear_namespace, buf, M.ns, expandedFirst, expandedLast + 1)
          if not ok then
            print("########")
          end
          M.highlight(buf, expandedFirst, expandedLast)
          i = i + 1
        end
        M.add_highlights(buf)
        M.checkBlock[buf] = {}
      end
    else
      M.checkBlock[buf] = {}
    end
  end
end

function M.attach(win)
  win = win or vim.api.nvim_get_current_win()
  if not M.is_valid_win(win) then
    return
  end

  local buf = vim.api.nvim_win_get_buf(win)

  if not M.bufs[buf] then
    vim.api.nvim_buf_attach(buf, false, {
      on_lines = function(event_type, bufid, changedtick, first, last_old, last_new)
        if not M.is_valid_buf(buf) then
          return true
        end
        M.Myredraw(buf, first, last_new)
      end,
      on_detach = function()
        M.bufs[buf] = nil
        M.checkBlock[buf] = {}
      end,
    })
    local highlighter = require("vim.treesitter.highlighter")
    local hl = highlighter.active[buf]
    if hl then
      hl.tree:register_cbs({
        on_bytes = function(bufid, changedtick, start_row, start_col, start_byte)
          M.Myredraw(buf, start_row, start_row, 2)
        end,
        on_changedtree = function(changes)
          for i, ch in ipairs(changes or {}) do
            M.Myredraw(buf, ch[1], ch[4], 3)
          end
        end,
      })
    end
    M.bufs[buf] = true

    M.highlight(buf, 0, vim.api.nvim_buf_line_count(buf))
    M.add_highlights(buf)
    M.wins[win] = true
    -- elseif not M.wins[win] then
  end
end

function M.stop()
  M.wins = {}
  for buf, _ in pairs(M.bufs) do
    if vim.api.nvim_buf_is_valid(buf) then
      pcall(vim.api.nvim_buf_clear_namespace, buf, M.ns, 0, -1)
    end
  end
  M.bufs = {}
end

function M.start()
  M.stop()
  M.addHlGroup()
  vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    group = vim.api.nvim_create_augroup("Colcom", { clear = true }),
    callback = function(args)
      M.attach()
    end,
    pattern = M.patterns,
  })

  for _, win in pairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local name = vim.api.nvim_buf_get_name(buf)
    for _, pat in ipairs(M.patterns) do
      if vim.fn.match(name, pat) ~= -1 then
        M.attach(win)
        break
      end
    end
  end
end

return M
