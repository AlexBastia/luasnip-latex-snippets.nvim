-- [
-- snip_env + autosnippets
-- ]
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local extras = require("luasnip.extras")
local rep = extras.rep
local fmta = require("luasnip.extras.fmt").fmta
local autosnippet = ls.extend_decorator.apply(s, { snippetType = "autosnippet" })

--[
-- personal imports
--]
local tex = require("luasnip-latex-snippets.luasnippets.tex.utils.conditions")
local make_condition = require("luasnip.extras.conditions").make_condition
local in_bullets_cond = make_condition(tex.in_bullets)
local line_begin = require("luasnip.extras.conditions.expand").line_begin

M = {
  s({ trig = 'fig', name = 'figure', dscr = 'template to add a centered image' },
    fmta([[
    \begin{figure}[h!]
      \centering
      \includegraphics[width=0.5\textwidth]{<>}
    \end{figure}<>
    ]],
      { i(1), i(0) }
    ), { condition = tex.in_text, show_condition = tex.in_text }),
  s({ trig = 'beg', name = 'begin/end', dscr = 'begin/end environment (generic)' },
    fmta([[
    \begin{<>}
    <>
    \end{<>}
    ]],
      { i(1), i(0), rep(1) }
    ), { condition = tex.in_text, show_condition = tex.in_text }),

  s({ trig = "-i", name = "itemize", dscr = "bullet points (itemize)" },
    fmta([[
    \begin{itemize}
    \item <>
    \end{itemize}
    ]],
      { c(1, { i(0), sn(nil, fmta(
        [[
        [<>] <>
        ]],
        { i(1), i(0) })) })
      }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }),

  -- requires enumitem
  s({ trig = "-e", name = "enumerate", dscr = "numbered list (enumerate)" },
    fmta([[
    \begin{enumerate}<>
    \item <>
    \end{enumerate}
    ]],
      { c(1, { t(""), sn(nil, fmta(
        [[
        [label=<>]
        ]],
        { c(1, { t("(\\alph*)"), t("(\\roman*)"), i(1) }) })) }),
        c(2, { i(0), sn(nil, fmta(
          [[
        [<>] <>
        ]],
          { i(1), i(0) })) })
      }
    ),
    { condition = tex.in_text, show_condition = tex.in_text }),

  -- generate new bullet points
  autosnippet({ trig = "--", hidden = true }, { t("\\item") },
    { condition = in_bullets_cond * line_begin, show_condition = in_bullets_cond * line_begin }
  ),
  autosnippet({ trig = "!-", name = "bullet point", dscr = "bullet point with custom text" },
    fmta([[
    \item [<>]<>
    ]],
      { i(1), i(0) }),
    { condition = in_bullets_cond * line_begin, show_condition = in_bullets_cond * line_begin }
  ),
}

return M
