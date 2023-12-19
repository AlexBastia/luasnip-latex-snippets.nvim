-- [
-- snip_env + autosnippets
-- ]
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local f = ls.function_node
local fmta = require("luasnip.extras.fmt").fmta
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

--[
-- personal imports
--]
local tex = require("luasnip-latex-snippets.luasnippets.tex.utils.conditions")
local single_command_snippet = require("luasnip-latex-snippets.luasnippets.tex.utils.scaffolding")
.single_command_snippet
local reference_snippet_table = {
  a = "auto",
  c = "c",
  C = "C",
  e = "eq",
  r = ""
}

M = {
  autosnippet({ trig = 'alab', name = 'label', dscr = 'add a label' },
    fmta([[
    \label{<>:<>}<>
    ]],
      { i(1), i(2), i(0) })),

  autosnippet(
    { trig = '([acCer])ref', name = '(acC|eq)?ref', dscr = 'add a reference (with autoref, cref, eqref)', trigEngine =
    "pattern", hidden = true },
    fmta([[
    \<>ref{<>:<>}<>
    ]],
      { f(function(_, snip)
        return reference_snippet_table[snip.captures[1]]
      end),
        i(1), i(2), i(0) }),
    { condition = tex.in_text, show_condition = tex.in_text }),
}

local single_command_specs = {
  sec = {
    context = {
      name = "section",
      dscr = "section",
      priority = 250,
    },
    command = [[\section]],
    ext = { label = true, short = "sec" },
  },
  ssec = {
    context = {
      name = "subsection",
      dscr = "subsection",
      priority = 500
    },
    command = [[\subsection]],
    ext = { label = true, short = "subsec" },
  },
  sssec = {
    context = {
      name = "subsubsection",
      dscr = "subsubsection",
    },
    command = [[\subsubsection]],
    ext = { label = true, short = "sssec" },
  },
  ["sec*"] = {
    context = {
      name = "section*",
      dscr = "section*",
      priority = 250,
    },
    command = [[\section*]],
    ext = { label = true, short = "sec" },
  },
  ["ssec*"] = {
    context = {
      name = "subsection*",
      dscr = "subsection*",
      priority = 500
    },
    command = [[\subsection*]],
    ext = { label = true, short = "subsec" },
  },
  ["sssec*"] = {
    context = {
      name = "subsubsection*",
      dscr = "subsubsection*",
    },
    command = [[\subsubsection*]],
    ext = { label = true, short = "sssec" },
  },

  sq = { -- requires csquotes!
    context = {
      name = "enquote*",
      dscr = "single quotes",
    },
    command = [[\enquote*]],
  },
  qq = {
    context = {
      name = "enquote",
      dscr = "double quotes",
    },
    command = [[\enquote]],
  },
  bf = {
    context = {
      name = "textbf",
      dscr = "bold text",
      hidden = true,
    },
    command = [[\textbf]],
  },
  it = {
    context = {
      name = "textit",
      dscr = "italic text",
      hidden = true,
    },
    command = [[\textit]],
  },
  ttt = {
    context = {
      name = "texttt",
      dscr = "monospace text",
      hidden = true,
    },
    command = [[\texttt]],
  },

  sc = {
    context = {
      name = "textsc",
      dscr = "small caps",
      hidden = true,
    },
    command = [[\textsc]],
  },
  tu = {
    context = {
      name = "underline (text)",
      dscr = "underlined text in non-math mode",
      hidden = true,
    },
    command = [[\underline]],
  },
  tov = {
    context = {
      name = "overline (text)",
      dscr = "overline text in non-math mode",
      hidden = true,
    },
    command = [[\overline]],
  },
}

local single_command_snippets = {}
for k, v in pairs(single_command_specs) do
  table.insert(
    single_command_snippets,
    single_command_snippet(
      vim.tbl_deep_extend("keep", { trig = k }, v.context),
      v.command,
      v.opt or { condition = tex.in_text },
      v.ext or {}
    )
  )
end
vim.list_extend(M, single_command_snippets)

return M
