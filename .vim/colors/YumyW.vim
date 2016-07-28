" Edited by ahoka
" original author info below

" File:       hybrid.vim
" Maintainer: Andrew Wong (w0ng)
" URL:        https://github.com/w0ng/vim-hybrid
" Modified:   27 Jan 2013 07:33 AM AEST
" License:    MIT

" Description:"{{{
" ----------------------------------------------------------------------------
" The RGB colour palette is taken from Tomorrow-Night.vim:
" https://github.com/chriskempson/vim-tomorrow-theme
"
" The syntax highlighting scheme is taken from jellybeans.vim:
" https://github.com/nanotech/jellybeans.vim
"
" The code taken from solarized.vim
" https://github.com/altercation/vim-colors-solarized

"}}}
" Requirements And Recommendations:"{{{
" ----------------------------------------------------------------------------
" This colourscheme is intended for use on:
"   - gVim 7.3 for Linux, Mac and Windows.
"   - Vim 7.3 for Linux, using a 256 colour enabled terminal.
"
" By default, Vim will use the closest matching cterm equivalent of the RGB
" colours.
"
" However, Due to the limited 256 palette, colours in Vim and gVim will still
" be noticeably different. In order to get a uniform appearance and the way
" that this colourscheme was intended, it is HIGHLY recommended that you:
"
" 1.  Add these colours to ~/.Xresources:
"
"       https://gist.github.com/3278077
"
" 2.  Use Xresources colours by setting in ~/.vimrc:
"
"       let g:hybrid_use_Xresources = 1
"       colorscheme hybrid

"}}}
" Initialisation:"{{{
" ----------------------------------------------------------------------------
if !has("gui_running") && &t_Co < 256
  finish
endif

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let colors_name = "ahoka"

"}}}
" GUI And Cterm Palettes:"{{{
" ----------------------------------------------------------------------------
if has("gui_running")
  let s:vmode      = "gui"
  let s:background = "#1b1b1b"
  let s:foreground = "#e9e6e6"
  let s:selection  = "#3e3b3b"
  let s:line       = "#222222"
  let s:comment    = "#787676"
  let s:folded     = "#4e4e4e"
  let s:red        = "#cf7275"
  let s:orange     = "#c59f6f"
  let s:yellow     = "#edc472"
  let s:green      = "#9ebf7c"
  let s:aqua       = "#8ab4be"
  let s:blue       = "#94aad1"
  let s:magenta    = "#c98dad"
  let s:window     = "#222222"
  let s:darkcolumn = "#121212"
  let s:addbg      = "#5f875f"
  let s:addfg      = "#d7ffaf"
  let s:changebg   = "#5f5f87"
  let s:changefg   = "#d7d7ff"
else
  let s:vmode      = "cterm"
  let s:background = "234"
  let s:window     = "236"
  let s:darkcolumn = "233"
  let s:addbg      = "65"
  let s:addfg      = "193"
  let s:changebg   = "60"
  let s:changefg   = "189"
  let s:foreground = "15"
  let s:selection  = "8"
  let s:line       = "0"
  let s:comment    = "7"
  let s:folded     = "239"
  let s:red        = "9"
  let s:orange     = "3"
  let s:yellow     = "11"
  let s:green      = "10"
  let s:aqua       = "14"
  let s:blue       = "12"
  let s:magenta    = "13"
endif

"}}}
" Formatting Options:"{{{
" ----------------------------------------------------------------------------
let s:none   = "NONE"
let s:t_none = "NONE"
let s:n      = "NONE"
let s:c      = ",undercurl"
let s:r      = ",reverse"
let s:s      = ",standout"
let s:b      = ",bold"
let s:u      = ",underline"
let s:i      = ",italic"

"}}}
" Highlighting Primitives:"{{{
" ----------------------------------------------------------------------------
exe "let s:bg_none       = ' ".s:vmode."bg=".s:none      ."'"
exe "let s:bg_foreground = ' ".s:vmode."bg=".s:foreground."'"
exe "let s:bg_background = ' ".s:vmode."bg=".s:background."'"
exe "let s:bg_selection  = ' ".s:vmode."bg=".s:selection ."'"
exe "let s:bg_line       = ' ".s:vmode."bg=".s:line      ."'"
exe "let s:bg_comment    = ' ".s:vmode."bg=".s:comment   ."'"
exe "let s:bg_folded     = ' ".s:vmode."bg=".s:folded    ."'"
exe "let s:bg_red        = ' ".s:vmode."bg=".s:red       ."'"
exe "let s:bg_orange     = ' ".s:vmode."bg=".s:orange    ."'"
exe "let s:bg_yellow     = ' ".s:vmode."bg=".s:yellow    ."'"
exe "let s:bg_green      = ' ".s:vmode."bg=".s:green     ."'"
exe "let s:bg_aqua       = ' ".s:vmode."bg=".s:aqua      ."'"
exe "let s:bg_blue       = ' ".s:vmode."bg=".s:blue      ."'"
exe "let s:bg_magenta    = ' ".s:vmode."bg=".s:magenta   ."'"
exe "let s:bg_window     = ' ".s:vmode."bg=".s:window    ."'"
exe "let s:bg_darkcolumn = ' ".s:vmode."bg=".s:darkcolumn."'"
exe "let s:bg_addbg      = ' ".s:vmode."bg=".s:addbg     ."'"
exe "let s:bg_addfg      = ' ".s:vmode."bg=".s:addfg     ."'"
exe "let s:bg_changebg   = ' ".s:vmode."bg=".s:changebg  ."'"
exe "let s:bg_changefg   = ' ".s:vmode."bg=".s:changefg  ."'"

exe "let s:fg_none       = ' ".s:vmode."fg=".s:none      ."'"
exe "let s:fg_foreground = ' ".s:vmode."fg=".s:foreground."'"
exe "let s:fg_background = ' ".s:vmode."fg=".s:background."'"
exe "let s:fg_selection  = ' ".s:vmode."fg=".s:selection ."'"
exe "let s:fg_line       = ' ".s:vmode."fg=".s:line      ."'"
exe "let s:fg_comment    = ' ".s:vmode."fg=".s:comment   ."'"
exe "let s:fg_folded     = ' ".s:vmode."fg=".s:folded    ."'"
exe "let s:fg_red        = ' ".s:vmode."fg=".s:red       ."'"
exe "let s:fg_orange     = ' ".s:vmode."fg=".s:orange    ."'"
exe "let s:fg_yellow     = ' ".s:vmode."fg=".s:yellow    ."'"
exe "let s:fg_green      = ' ".s:vmode."fg=".s:green     ."'"
exe "let s:fg_aqua       = ' ".s:vmode."fg=".s:aqua      ."'"
exe "let s:fg_blue       = ' ".s:vmode."fg=".s:blue      ."'"
exe "let s:fg_magenta    = ' ".s:vmode."fg=".s:magenta   ."'"
exe "let s:fg_window     = ' ".s:vmode."fg=".s:window    ."'"
exe "let s:fg_darkcolumn = ' ".s:vmode."fg=".s:darkcolumn."'"
exe "let s:fg_addbg      = ' ".s:vmode."fg=".s:addbg     ."'"
exe "let s:fg_addfg      = ' ".s:vmode."fg=".s:addfg     ."'"
exe "let s:fg_changebg   = ' ".s:vmode."fg=".s:changebg  ."'"
exe "let s:fg_changefg   = ' ".s:vmode."fg=".s:changefg  ."'"

exe "let s:fmt_none      = ' ".s:vmode."=NONE".          " term=NONE"        ."'"
exe "let s:fmt_bold      = ' ".s:vmode."=NONE".s:b.      " term=NONE".s:b    ."'"
exe "let s:fmt_bldi      = ' ".s:vmode."=NONE".s:b.      " term=NONE".s:b    ."'"
exe "let s:fmt_undr      = ' ".s:vmode."=NONE".s:u.      " term=NONE".s:u    ."'"
exe "let s:fmt_undb      = ' ".s:vmode."=NONE".s:u.s:b.  " term=NONE".s:u.s:b."'"
exe "let s:fmt_undi      = ' ".s:vmode."=NONE".s:u.      " term=NONE".s:u    ."'"
exe "let s:fmt_curl      = ' ".s:vmode."=NONE".s:c.      " term=NONE".s:c    ."'"
exe "let s:fmt_ital      = ' ".s:vmode."=NONE".s:i.      " term=NONE".s:i    ."'"
exe "let s:fmt_stnd      = ' ".s:vmode."=NONE".s:s.      " term=NONE".s:s    ."'"
exe "let s:fmt_revr      = ' ".s:vmode."=NONE".s:r.      " term=NONE".s:r    ."'"
exe "let s:fmt_revb      = ' ".s:vmode."=NONE".s:r.s:b.  " term=NONE".s:r.s:b."'"

if has("gui_running")
  exe "let s:sp_none       = ' guisp=".s:none      ."'"
  exe "let s:sp_foreground = ' guisp=".s:foreground."'"
  exe "let s:sp_background = ' guisp=".s:background."'"
  exe "let s:sp_selection  = ' guisp=".s:selection ."'"
  exe "let s:sp_line       = ' guisp=".s:line      ."'"
  exe "let s:sp_comment    = ' guisp=".s:comment   ."'"
  exe "let s:sp_folded     = ' guisp=".s:folded    ."'"
  exe "let s:sp_red        = ' guisp=".s:red       ."'"
  exe "let s:sp_orange     = ' guisp=".s:orange    ."'"
  exe "let s:sp_yellow     = ' guisp=".s:yellow    ."'"
  exe "let s:sp_green      = ' guisp=".s:green     ."'"
  exe "let s:sp_aqua       = ' guisp=".s:aqua      ."'"
  exe "let s:sp_blue       = ' guisp=".s:blue      ."'"
  exe "let s:sp_magenta    = ' guisp=".s:magenta   ."'"
  exe "let s:sp_window     = ' guisp=".s:window    ."'"
  exe "let s:sp_addbg      = ' guisp=".s:addbg     ."'"
  exe "let s:sp_addfg      = ' guisp=".s:addfg     ."'"
  exe "let s:sp_changebg   = ' guisp=".s:changebg  ."'"
  exe "let s:sp_changefg   = ' guisp=".s:changefg  ."'"
else
  let s:sp_none       = ""
  let s:sp_foreground = ""
  let s:sp_background = ""
  let s:sp_selection  = ""
  let s:sp_line       = ""
  let s:sp_comment    = ""
  let s:sp_folded     = ""
  let s:sp_red        = ""
  let s:sp_orange     = ""
  let s:sp_yellow     = ""
  let s:sp_green      = ""
  let s:sp_aqua       = ""
  let s:sp_blue       = ""
  let s:sp_magenta    = ""
  let s:sp_window     = ""
  let s:sp_addbg      = ""
  let s:sp_addfg      = ""
  let s:sp_changebg   = ""
  let s:sp_changefg   = ""
endif

"}}}
" Vim Highlighting: (see :help highlight-groups)"{{{
" ----------------------------------------------------------------------------
exe "hi! ColorColumn"   .s:fg_none        .s:bg_line        .s:fmt_none
exe "hi! Conceal"       .s:fg_line       .s:bg_none        .s:fmt_none
"       Cursor"
"       CursorIM"
exe "hi! CursorColumn"  .s:fg_none        .s:bg_line        .s:fmt_none
exe "hi! CursorLine"    .s:fg_none        .s:bg_line        .s:fmt_none
exe "hi! Directory"     .s:fg_blue        .s:bg_none        .s:fmt_none
exe "hi! DiffAdd"       .s:fg_addfg       .s:bg_addbg       .s:fmt_none
exe "hi! DiffChange"    .s:fg_changefg    .s:bg_changebg    .s:fmt_none
exe "hi! DiffDelete"    .s:fg_background  .s:bg_red         .s:fmt_none
exe "hi! DiffText"      .s:fg_background  .s:bg_blue        .s:fmt_none
exe "hi! ErrorMsg"      .s:fg_background  .s:bg_red         .s:fmt_stnd
exe "hi! VertSplit"     .s:fg_darkcolumn  .s:bg_none        .s:fmt_none
exe "hi! Folded"        .s:fg_folded      .s:bg_darkcolumn  .s:fmt_none
exe "hi! FoldColumn"    .s:fg_selection   .s:bg_darkcolumn  .s:fmt_none
exe "hi! SignColumn"    .s:fg_none        .s:bg_darkcolumn  .s:fmt_none
"       Incsearch"
exe "hi! LineNr"        .s:fg_selection   .s:bg_darkcolumn  .s:fmt_none
exe "hi! CursorLineNr"  .s:fg_red         .s:bg_background  .s:fmt_none
exe "hi! MatchParen"    .s:fg_background  .s:bg_aqua        .s:fmt_none
exe "hi! ModeMsg"       .s:fg_green       .s:bg_none        .s:fmt_none
exe "hi! MoreMsg"       .s:fg_green       .s:bg_none        .s:fmt_none
exe "hi! NonText"       .s:fg_background  .s:bg_none        .s:fmt_none
exe "hi! Pmenu"         .s:fg_foreground  .s:bg_darkcolumn  .s:fmt_none
exe "hi! PmenuSel"      .s:fg_foreground  .s:bg_darkcolumn  .s:fmt_revr
exe "hi! PmenuSbar"     .s:fg_foreground  .s:bg_darkcolumn  .s:fmt_none
"       PmenuThumb"
exe "hi! Question"      .s:fg_green       .s:bg_none        .s:fmt_none
exe "hi! Search"        .s:fg_background  .s:bg_magenta     .s:fmt_undr
exe "hi! SpecialKey"    .s:fg_selection   .s:bg_none        .s:fmt_none
exe "hi! SpellBad"      .s:fg_red         .s:bg_none        .s:fmt_undr
exe "hi! SpellCap"      .s:fg_blue        .s:bg_none        .s:fmt_undr
exe "hi! SpellLocal"    .s:fg_aqua        .s:bg_none        .s:fmt_undr
exe "hi! SpellRare"     .s:fg_magenta     .s:bg_none        .s:fmt_undr
exe "hi! StatusLine"    .s:fg_comment     .s:bg_background  .s:fmt_revr
exe "hi! StatusLineNC"  .s:fg_window      .s:bg_comment     .s:fmt_revr
exe "hi! TabLine"       .s:fg_comment     .s:bg_line        .s:fmt_none
exe "hi! TabLineFill"   .s:fg_foreground  .s:bg_line        .s:fmt_none
exe "hi! TabLineSel"    .s:fg_foreground  .s:bg_background  .s:fmt_none
exe "hi! Title"         .s:fg_red         .s:bg_none        .s:fmt_none
exe "hi! Visual"        .s:fg_none        .s:bg_selection   .s:fmt_none
"       VisualNos"
exe "hi! WarningMsg"    .s:fg_red         .s:bg_none        .s:fmt_none
"       WildMenu"

" gitgutter
exe "hi! GitGutterAdd"          .s:fg_green .s:bg_darkcolumn .s:fmt_none
exe "hi! GitGutterChange"       .s:fg_yellow.s:bg_darkcolumn .s:fmt_none
exe "hi! GitGutterDelete"       .s:fg_red   .s:bg_darkcolumn .s:fmt_none
exe "hi! GitGutterChangeDelete" .s:fg_yellow.s:bg_darkcolumn .s:fmt_none

" Syntastic
exe "hi! SyntasticErrorSign"    .s:fg_red   .s:bg_darkcolumn .s:fmt_undr
exe "hi! SyntasticWarningSign"  .s:fg_yellow.s:bg_darkcolumn .s:fmt_none

" Misc
exe "hi! cppSTLnamespace"       .s:fg_orange.s:bg_none       .s:fmt_none

if has('gui_running')
  exe "hi! Normal" .s:fg_foreground .s:bg_background .s:fmt_none
else
  exe "hi! Normal" .s:fg_foreground .s:bg_none .s:fmt_none
endif

"}}}
" Generic Syntax Highlighting: (see :help group-name)"{{{
" ----------------------------------------------------------------------------
exe "hi! Comment"         .s:fg_comment     .s:bg_none        .s:fmt_none

exe "hi! Constant"        .s:fg_red         .s:bg_none        .s:fmt_none
exe "hi! String"          .s:fg_green       .s:bg_none        .s:fmt_none
"       Character"
"       Number"
"       Boolean"
"       Float"

exe "hi! Identifier"      .s:fg_magenta     .s:bg_none        .s:fmt_none
exe "hi! Function"        .s:fg_yellow      .s:bg_none        .s:fmt_none

exe "hi! Statement"       .s:fg_blue        .s:bg_none        .s:fmt_none
"       Conditional"
"       Repeat"
"       Label"
exe "hi! Operator"        .s:fg_aqua        .s:bg_none        .s:fmt_none
"       Keyword"
"       Exception"

exe "hi! PreProc"         .s:fg_aqua        .s:bg_none        .s:fmt_none
"       Include"
"       Define"
"       Macro"
"       PreCondit"

exe "hi! Type"            .s:fg_yellow      .s:bg_none        .s:fmt_none
exe "hi! StorageClass"    .s:fg_orange      .s:bg_none        .s:fmt_none
exe "hi! Structure"       .s:fg_aqua        .s:bg_none        .s:fmt_none
"       Typedef"

exe "hi! Special"         .s:fg_green       .s:bg_none        .s:fmt_none
"       SpecialChar"
"       Tag"
"       Delimiter"
"       SpecialComment"
"       Debug"
"
exe "hi! Underlined"      .s:fg_blue        .s:bg_none        .s:fmt_none

exe "hi! Ignore"          .s:fg_none        .s:bg_none        .s:fmt_none

exe "hi! Error"           .s:fg_red         .s:bg_none        .s:fmt_undr

exe "hi! Todo"            .s:fg_addfg       .s:bg_none        .s:fmt_none

" Quickfix window highlighting
exe "hi! qfLineNr"        .s:fg_yellow      .s:bg_none        .s:fmt_none
"   qfFileName"
"   qfLineNr"
"   qfError"

"}}}
" Diff Syntax Highlighting:"{{{
" ----------------------------------------------------------------------------
" Diff
"       diffOldFile
"       diffNewFile
"       diffFile
"       diffOnly
"       diffIdentical
"       diffDiffer
"       diffBDiffer
"       diffIsA
"       diffNoEOL
"       diffCommon
hi! link diffRemoved Constant
"       diffChanged
hi! link diffAdded Special
"       diffLine
"       diffSubname
"       diffComment

"}}}
