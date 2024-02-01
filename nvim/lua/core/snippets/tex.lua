local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

local in_mathzone = function()
    -- The `in_mathzone` function requires the VimTeX plugin
    return vim.fn['vimtex#syntax#in_mathzone']() == 1
end
return {
    -- math modes
    s({ trig = "mt", snippetType = "autosnippet" },
        fmta("$<>$ <>", { i(1), i(2) })
    ),
    s({ trig = "mmt", snippetType = "autosnippet" },
        fmta("$$<>$$ <>", { i(1), i(2) })
    ),
    s({ trig = "align", snippetType = "autosnippet" },
        fmta([[
    \begin{align*}
      <>
    \end{align*}
    ]], { i(1) })
    ),
    s({ trig = "text", snippetType = "autosnippet" },
        fmta("\\text{<>} ", { i(1) }),
        { condition = in_mathzone }
    ),
    s({ trig = "piecewise", snippetType = "autosnippet" },
        fmta([[
      <>=\begin{cases}
			<> & \text{<>} \\
			<> & \text{<>}
      \end{cases}
    ]], { i(1), i(2), i(3), i(4), i(5) })
    ),
    s({ trig = "cases", snippetType = "autosnippet" },
        fmta([[
    \[
      \begin{minipage}{.50\linewidth}
        \centering
        \textbf{Case} <>
        \begin{align*}
        \end{align*}
      \end{minipage}%
      \begin{minipage}{.50\linewidth}
        \centering
        \textbf{Case} <>
        \begin{align*}
        \end{align*}
      \end{minipage}
    \]
    ]], { i(1), i(2) })
    ),
    s({ trig = "gaussian", snippetType = "autosnippet" },
        fmta([[
	\left[
		\begin{array}{ccc|c}
			<> & <> & <> & <>  \\
		\end{array}
		\right]
    ]], { i(1), i(2), i(3), i(4) })
    ),
    s({ trig = "linsys", snippetType = "autosnippet" },
        fmta([[
    \[
        \begin{matrix}
        <> &  \\
        \end{matrix}
    \]
    ]], { i(1) })
    ),
    -- font Modes
    s({ trig = "Bld", snippetType = "autosnippet" },
        fmta("\\textbf{<>} ", { i(1) })
    ),
    -- Discrete Math
    s({ trig = "st.", snippetType = "autosnippet" },
        { t("such that ") }
    ),
    s({ trig = "fix12", snippetType = "autosnippet" },
        fmta("fix $x_1, x_2 \\in <>$", { i(1) })
    ),
    s({ trig = "Rn", snippetType = "autosnippet" },
        { t("\\mathbb{R} ") },
        { t("\\mathbb{R}") },
        { condition = in_mathzone }
    ),
    s({ trig = "Nn", snippetType = "autosnippet" },
        { t("\\mathbb{N} ") },
        { t("\\mathbb{N}") },
        { condition = in_mathzone }
    ),
    s({ trig = "Qn", snippetType = "autosnippet" },
        { t("\\mathbb{Q} ") },
        { t("\\mathbb{Q}") },
        { condition = in_mathzone }
    ),
    s({ trig = "Zn", snippetType = "autosnippet" },
        { t("\\mathbb{Z} ") },
        { t("\\mathbb{Z}") },
        { condition = in_mathzone }
    ),
    s({ trig = "and", snippetType = "autosnippet" },
        { t("\\land ") },
        { condition = in_mathzone }
    ),
    s({ trig = "or", snippetType = "autosnippet" },
        { t("\\lor ") },
        { condition = in_mathzone }
    ),
    s({ trig = "implies", snippetType = "autosnippet" },
        { t("\\implies") },
        { condition = in_mathzone }
    ),
    s({ trig = "dots", snippetType = "autosnippet" },
        { t("\\dots") },
        { condition = in_mathzone }
    ),
    s({ trig = "forall", snippetType = "autosnippet" },
        { t("\\forall") },
        { condition = in_mathzone }
    ),
    s({ trig = "exists", snippetType = "autosnippet" },
        { t("\\exists") },
        { condition = in_mathzone }
    ),
    -- sets
    s({ trig = "set", snippetType = "autosnippet" },
        fmta("\\{<> \\}", { i(1) }),
        { condition = in_mathzone }
    ),
    s({ trig = "ins", snippetType = "autosnippet" },
        { t("\\in ") },
        { condition = in_mathzone }
    ),
    s({ trig = "sub", snippetType = "autosnippet" },
        { t("\\subseteq") },
        { condition = in_mathzone }
    ),
    s({ trig = "cross", snippetType = "autosnippet" },
        { t("\\times") },
        { condition = in_mathzone }
    ),
    s({ trig = "union", snippetType = "autosnippet" },
        { t("\\cup") },
        { condition = in_mathzone }
    ),
    s({ trig = "inter", snippetType = "autosnippet" },
        { t("\\cap") },
        { condition = in_mathzone }
    ),
    s({ trig = "empty", snippetType = "autosnippet" },
        { t("\\emptyset") },
        { condition = in_mathzone }
    ),
    -- general math
    s({ trig = "geq", snippetType = "autosnippet" },
        { t("\\geq") },
        { condition = in_mathzone }
    ),
    s({ trig = "of", snippetType = "autosnippet" },
        { t("\\circ") },
        { condition = in_mathzone }
    ),
    s({ trig = "sq", snippetType = "autosnippet" },
        fmta("\\sqrt{<>}", { i(1) }),
        { condition = in_mathzone }
    ),
    s({ trig = "FoG", snippetType = "autosnippet" },
        { t("f\\circ g") },
        { condition = in_mathzone }
    ),
    s({ trig = "GoF", snippetType = "autosnippet" },
        { t("g\\circ f") },
        { condition = in_mathzone }
    ),
    s({ trig = "neq", snippetType = "autosnippet" },
        { t("\\neq") },
        { condition = in_mathzone }
    ),
    s({ trig = "leq", snippetType = "autosnippet" },
        { t("\\leq") },
        { condition = in_mathzone }
    ),

    -- fractions, subscript, superscript, and other regex triggers
    s({ trig = "([%w%p]+)/", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("\\frac{<>}{<>}",
            { f(function(_, snip) return snip.captures[1] end, {}),
                i(1)
            }),
        { condition = in_mathzone }
    ),
    s({ trig = "([%a])([%d])", regTrig = true, wordTrig = false, snippetType = "autosnippet" },
        fmta("<>_{<><>}",
            {
                f(function(_, snip) return snip.captures[1] end, {}),
                f(function(_, snip) return snip.captures[2] end, {}),
                i(1)
            }),
        { condition = in_mathzone }
    ),
}
