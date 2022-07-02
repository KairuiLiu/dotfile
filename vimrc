"====================================
"===  Basic setting for vim use   ===
"====================================
set encoding=utf-8                  "Encoding UTF-8, to use Gvim correct
syntax on                           "hilight_base
let mapleader = "\<space>"          "change leader key
language C                          "Using English
set nocompatible                    "Compaty vi..
filetype on
filetype indent on
filetype plugin on
set mouse=a                         "Mouse enable
let &t_ut=''
set expandtab                       "Convent Tab to space
set tabstop=4						"Tab config
set shiftwidth=4
set softtabstop=4
set list							"Show '$' at cursor
set listchars=tab:▸\ ,trail:▫		"Show Tab & space
set scrolloff=5						"At least n row before/after cursor
set backspace=indent,eol,start		"Let Backspace cross row
set foldmethod=indent				"fold
set foldlevel=99
let &t_SI = "\<Esc>]50;CursorShape=1\x7"	"Theme of cursor
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"
set laststatus=2					"Always show Status bar
set autoindent						"ident

"====================================
"===  editor  =======================
"====================================
map <silent> <F2> :if &guioptions =~# 'T' <Bar>
		\set guioptions-=T <Bar>
		\set guioptions-=m <bar>
	\else <Bar>
		\set guioptions =T <Bar>
		\set guioptions =m <Bar>
	\endif<CR>
set guioptions-=m   "Hide Menu
set guioptions-=T   "Hide Tool-Bar
set guioptions-=r   "hide right scroll
set guioptions-=b   "hide buttom scoll
set guioptions-=L   "hide left scroll
set number			"row number
set relativenumber"relative row number
set cursorline		"hilight line cursor
set cursorcolumn	"hilight colum cursor
set wrap			"autowrap
set showcmd			"show point out
set wildmenu
set hlsearch		"search hilight
exec "nohlsearch"	
set incsearch		"real time search hilight
set ignorecase		"ignore text-transform
set smartcase		"smart text-transform

map rc : e ~\.vimrc<CR> 
map S : w<CR>
map s <nop>
map Q :q<CR>
map R :source $MYVIMRC<CR>
noremap <LEADER><CR>  :nohlsearch<CR>
map spl :set splitright<CR>:vsplit<CR>
map sph :set nosplitright<CR>:vsplit<CR>
map spj :set splitbelow<CR>:split<CR>
map spk :set nosplitbelow<CR>:split<CR>

map <A-h> <C-w>h
map <A-j> <C-w>j
map <A-k> <C-w>k
map <A-l> <C-w>l
map <A-=> :vertical resize+5 <CR> 
map <A--> :vertical resize-5 <CR> 
map <A-+> :resize+5 <CR> 
map <A-_> :resize-5 <CR> 
map sv <C-w>t<c-W>H
map sv <C-w>t<c-W>K

map tu :tabe<CR>
map tc :tabc<CR>
" Move around tabs with tn and ti
map tp :-tabnext<CR>
map tn :+tabnext<CR>
" Move the tabs with tmn and tmi
map tmn :-tabmove<CR>
map tmi :+tabmove<CR>
"jump ])}
inoremap <C-l> <Right>

"====================================
"=== Processer ======================
"====================================
map  <F9>  :w<CR>:call Run()<CR>
imap <F9>  <ESC>:w<CR>:call Run()<CR>
map  <F10> :w<CR>:call Debug()<CR>
imap <F10> <ESC>:w<CR>:call Debug()<CR>

func!  Debug()
    if expand("%:e") == "c" || expand("%:e") == "cc" || expand("%:e") == "cxx" || expand("%:e") == "cpp"
        exe ":setlocal makeprg=".'g++\ %\ -o\ %<\ -gstabs+'
        echohl WarningMsg | echo " compiling..."
        silent make
        exe ":!gdb %<"
        redraw!
        echohl WarningMsg | echo " Debug finish! :-)"
    else
        redraw!
        echo "Language not support! :-("
    endif
endfunc

func! Run()
    if expand("%:e") == "py"
        ! Python -u "%<.py"
        redraw!
        echohl WarningMsg | echo " Running finish! :-)"
    elseif expand("%:e") == "c" || expand("%:e") == "cc" || expand("%:e") == "cxx" || expand("%:e") == "cpp"
        echo " compiling..."
        :! g++ "%" -o "%<.out" && "./%<.out"
        redraw!
        echohl WarningMsg | echo " Running finish! :-)"
    elseif expand("%:e") == "r"
        exe ":! Rscript %"
        redraw!
        echohl WarningMsg | echo " Running finish! :-)"
    elseif expand("%:e") == "vbs"
        exe ":! %"
        redraw!
        echohl WarningMsg | echo " Running finish! :-)"
        redraw!
        echohl WarningMsg | echo " Running finish! :-)"
    elseif expand("%:e") == "md"
        :MarkdownPreview
        redraw!
        echohl WarningMsg | echo " Running on Chrome! :-)"
    elseif expand("%:e") == "tex"
        "<localleader>ll
        \\ll
        ":vimtex-compile
    else
        redraw!
        echo "Language not support! :-("
    endif
endfunction

"====================================
"=== Plug config ====================
"====================================
"------- xkb-switch --------
"copy dll to $VIM, and note bit
let g:XkbSwitchEnabled     = 1
let g:XkbSwitchIMappings   = ['cn']
let g:XkbSwitchIMappingsTr = {'cn': {'<': '', '>': ''}}

"------- ondotree ----------
map <F5> :UndotreeToggle<CR>

"------- NERDTreeToggle ----
map ff :NERDTreeToggle<CR> 

"------- Airline -----------
"set ambiwidth=double                    " 设置为双字宽显示，否则无法完整显示如:☆
let g:airline_powerline_fonts = 1
" 开启tabline
let g:airline#extensions#tabline#enabled = 1      "tabline中当前buffer两端的分隔字符
let g:airline#extensions#tabline#left_sep = ' '   "tabline中未激活buffer两端的分隔字符
let g:airline#extensions#tabline#left_alt_sep = '|'      "tabline中buffer显示编号
let g:airline#extensions#tabline#buffer_nr_show = 1      
" 映射切换buffer的键位
nnoremap [b :bp<CR>
nnoremap ]b :bn<CR>

"------- vim-autodormat ----
"python need
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_remove_trailing_spaces = 0
noremap <F3> :Autoformat<CR>
let g:autoformat_verbosemode=1

"------- nerdcommenter -----
map <C-m> <leader>cc
map <A-m> <leader>cu
unmap <CR>

" 1. vscode defult 2. author defult 3. vscode show
"	\	'guifgs': ['#B21212', '#1B9CED','#FFFC00'],
"	\	'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick'],
"	\	'guifgs': ['#C186BF', '#268EDB','#F79318'],
"------- Rainbow -----------
	let g:rainbow_conf = {
	\	'guifgs': ['#C186BF', '#268EDB','#F79318'],
	\	'ctermfgs': ['lightblue', 'lightyellow', 'lightcyan', 'lightmagenta'],
	\	'operators': '_,_',
	\	'parentheses': ['start=/(/ end=/)/ fold', 'start=/\[/ end=/\]/ fold', 'start=/{/ end=/}/ fold'],
	\	'separately': {
	\		'*': {},
	\		'tex': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/'],
	\		},
	\		'lisp': {
	\			'guifgs': ['royalblue3', 'darkorange3', 'seagreen3', 'firebrick', 'darkorchid3'],
	\		},
    \		'vim': {
	\			'parentheses': ['start=/(/ end=/)/', 'start=/\[/ end=/\]/', 'start=/{/ end=/}/ fold', 'start=/(/ end=/)/ containedin=vimFuncBody', 'start=/\[/ end=/\]/ containedin=vimFuncBody', 'start=/{/ end=/}/ fold containedin=vimFuncBody'],
	\		},
	\		'html': {
	\			'parentheses': ['start=/\v\<((area|base|br|col|embed|hr|img|input|keygen|link|menuitem|meta|param|source|track|wbr)[ >])@!\z([-_:a-zA-Z0-9]+)(\s+[-_:a-zA-Z0-9]+(\=("[^"]*"|'."'".'[^'."'".']*'."'".'|[^ '."'".'"><=`]*))?)*\>/ end=#</\z1># fold'],
	\		},
	\		'css': 0,
	\	}
	\}
let g:rainbow_active = 1
"------- ALE ---------------
"if need change airline icon:
"   open ~/.vim/plugged/vim-airline/autoload/airline/extensions/ale.vim and replace
"   let error_symbol = get(g:, 'airline#extensions#ale#error_symbol', '😡')
"   let warning_symbol = get(g:, 'airline#extensions#ale#warning_symbol', '📛:')
"始终开启标志列
let g:ale_sign_column_always = 1
let g:ale_set_highlights = 0
"自定义error和warning图标
"在vim自带的状态栏中整合ale
let g:ale_sign_error = '✗'
let g:ale_sign_warning = '⚡'
"let g:ale_sign_warning = '?'
let g:ale_statusline_format = ['✗ %d', '⚡ %d', '✔ OK']
"显示Linter名称,出错或警告等相关信息
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
"普通模式下，sp前往上一个错误或警告，sn前往下一个错误或警告
nmap sp <Plug>(ale_previous_wrap)
nmap sn <Plug>(ale_next_wrap)
"<Leader>s触发/关闭语法检查
nmap <Leader>s :ALEToggle<CR>
"<Leader>d查看错误或警告的详细信息
nmap <Leader>d :ALEDetail<CR>
"set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}\ %{ALEGetStatusLine()}
"cpp NOT C++
let g:ale_linters = {
\   'cpp': ['gcc'],
\   'c': ['gcc'],
\   'python': ['pylint'],
\}

"------- MarkDown ----------
"first use :MarkdownPreviewToggel  to wake Plug
let g:vim_markdown_math = 1
let g:vmt_auto_update_on_save = 0
let g:mkdp_path_to_chrome = "C:\Program Files (x86)\Google\Chrome\Application"
let g:mkdp_markdown_css=''

"------- MDTable -----------
"||+esc
let g:table_mode_corner = '|'
let g:table_mode_border=0
let g:table_mode_fillchar=' '

function! s:isAtStartOfLine(mapping)
  let text_before_cursor = getline('.')[0 : col('.')-1]
  let mapping_pattern = '\V' . escape(a:mapping, '\')
  let comment_pattern = '\V' . escape(substitute(&l:commentstring, '%s.*$', '', ''), '\')
  return (text_before_cursor =~? '^' . ('\v(' . comment_pattern . '\v)?') . '\s*\v' . mapping_pattern . '\v$')
endfunction

inoreabbrev <expr> <bar><bar>
          \ <SID>isAtStartOfLine('\|\|') ?
          \ '<c-o>:TableModeEnable<cr><bar><space><bar><left><left>' : '<bar><bar>'
inoreabbrev <expr> __
          \ <SID>isAtStartOfLine('__') ?
          \ '<c-o>:silent! TableModeDisable<cr>' : '__'

"------- LaTeX -------------
" Autocomprtr not realize
" F9 not drc
" add SumatraPDF Path
let g:tex_flavor='latex'
let g:vimtex_view_general_viewer = 'SumatraPDF'
let g:vimtex_view_general_options_latexmk = '-reuse-instance'
let g:vimtex_view_general_options
\ = '-reuse-instance -forward-search @tex @line @pdf'
\ . ' -inverse-search "' . exepath(v:progpath)
\ . ' --servername ' . v:servername
\ . ' --remote-send \"^<C-\^>^<C-n^>'
\ . ':execute ''drop '' . fnameescape(''\%f'')^<CR^>'
\ . ':\%l^<CR^>:normal\! zzzv^<CR^>'
\ . ':call remote_foreground('''.v:servername.''')^<CR^>^<CR^>\""'
set conceallevel=1
let g:tex_conceal='abdmg'

"------- YCM ---------------
set runtimepath+=~/.vim/plugged/YouCompleteMe
autocmd InsertLeave * if pumvisible() == 0|pclose|endif "离开插入模式后自动关闭预览窗口"
let g:ycm_collect_identifiers_from_tags_files = 1           " 开启 YCM基于标签引擎
let g:ycm_collect_identifiers_from_comments_and_strings = 1 " 注释与字符串中的内容也用于补全
let g:syntastic_ignore_files=[".*\.py$"]
let g:ycm_seed_identifiers_with_syntax = 1                  " 语法关键字补全
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0                            " 关闭加载.ycm_extra_conf.py提示
let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']  " 映射按键,没有这个会拦截掉tab, 导致其他插件的tab不能用.
let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
let g:ycm_complete_in_comments = 1                          " 在注释输入中也能补全
let g:ycm_complete_in_strings = 1                           " 在字符串输入中也能补全
let g:ycm_collect_identifiers_from_comments_and_strings = 1 " 注释和字符串中的文字也会被收入补全
"let g:ycm_global_ycm_extra_conf='~/.vim/bundle/YouCompleteMe/third_party/ycmd/cpp/ycm/.ycm_extra_conf.py'
let g:ycm_global_ycm_extra_conf='~/.vim/plugged/YouCompleteMe/third_party/ycmd/cpp/.ycm_extra_conf.py'
let g:ycm_show_diagnostics_ui = 0                           " 禁用语法检查
inoremap <expr> <CR> pumvisible() ? "\<C-y>" : "\<CR>"
" 回车即选中当前项
nnoremap <c-j> :YcmCompleter GoToDefinitionElseDeclaration<CR>
" 跳转到定义处
let g:ycm_min_num_of_chars_for_completion=2                 " 从第2个键入字符就开始罗列匹配项
let g:ycm_key_invoke_completion = '<c-z>'
let g:ycm_semantic_triggers =  {
			\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
			\ 'cs,lua,javascript': ['re!\w{2}'],
			\ }

"------- Python-mode -------
"开启警告
let g:pymode_warnings = 0
"保存文件时自动删除无用空格
let g:pymode_trim_whitespaces = 1
let g:pymode_options = 1
"显示允许的最大长度的列
let g:pymode_options_colorcolumn = 1
"设置QuickFix窗口的最大，最小高度
let g:pymode_quickfix_minheight = 3
let g:pymode_quickfix_maxheight = 10
"使用python3
let g:pymode_python = 'python3'
"使用PEP8风格的缩进
let g:pymode_indent = 1
"取消代码折叠
let g:pymode_folding = 0
"开启python-mode定义的移动方式
let g:pymode_motion = 1
"启用python-mode内置的python文档，使用K进行查找
let g:pymode_doc = 1
let g:pymode_doc_bind = 'K'
"自动检测并启用virtualenv
let g:pymode_virtualenv = 1
"不使用python-mode运行python代码
let g:pymode_run = 0
"let g:pymode_run_bind = '<Leader>r'
"不使用python-mode设置断点
let g:pymode_breakpoint = 0
"let g:pymode_breakpoint_bind = '<leader>b'
"启用python语法检查
let g:pymode_lint = 1
"修改后保存时进行检查
let g:pymode_lint_on_write = 0
"编辑时进行检查
let g:pymode_lint_on_fly = 0
let g:pymode_lint_checkers = ['pyflakes', 'pep8']
"发现错误时不自动打开QuickFix窗口
let g:pymode_lint_cwindow = 0
"侧边栏不显示python-mode相关的标志
let g:pymode_lint_signs = 0
"let g:pymode_lint_todo_symbol = 'WW'
"let g:pymode_lint_comment_symbol = 'CC'
"let g:pymode_lint_visual_symbol = 'RR'
"let g:pymode_lint_error_symbol = 'EE'
"let g:pymode_lint_info_symbol = 'II'
"let g:pymode_lint_pyflakes_symbol = 'FF'
"启用重构
let g:pymode_rope = 1
"不在父目录下查找.ropeproject，能提升响应速度
let g:pymode_rope_lookup_project = 0
"光标下单词查阅文档
let g:pymode_rope_show_doc_bind = '<C-c>d'
"项目修改后重新生成缓存
let g:pymode_rope_regenerate_on_write = 1
"开启补全，并设置<C-Tab>为默认快捷键
let g:pymode_rope_completion = 1
let g:pymode_rope_complete_on_dot = 1
let g:pymode_rope_completion_bind = '<C-Tab>'
"<C-c>g跳转到定义处，同时新建竖直窗口打开
let g:pymode_rope_goto_definition_bind = '<C-c>g'
let g:pymode_rope_goto_definition_cmd = 'vnew'
"重命名光标下的函数，方法，变量及类名
let g:pymode_rope_rename_bind = '<C-c>rr'
"重命名光标下的模块或包
let g:pymode_rope_rename_module_bind = '<C-c>r1r'
"开启python所有的语法高亮
let g:pymode_syntax = 1
let g:pymode_syntax_all = 1
"高亮缩进错误
let g:pymode_syntax_indent_errors = g:pymode_syntax_all
"高亮空格错误
let g:pymode_syntax_space_errors = g:pymode_syntax_all

"------- vim-cpp-hilight ---
let g:cpp_class_scope_highlight = 1
let g:cpp_member_variable_highlight = 1
let g:cpp_class_decl_highlight = 1
let g:cpp_experimental_simple_template_highlight = 1
let g:cpp_experimental_template_highlight = 1
let g:cpp_concepts_highlight = 1

"------- Start -------------
"let g:startify_custom_header = [
"            \ '+------------------------------+',
"            \ '|                              |',
"            \ '|    Still waters run deep!    |',
"            \ '|                              |',
"            \ '+----------------+-------------+',
"            \]
"let g:startify_custom_footer = [
"            \ '+------------------------------+',
"            \ '|     Keep an open mind!       |',
"            \ '+----------------+-------------+',
"            \]
let g:startify_files_number = 5
"let g:startify_custom_indices = map(range(1,100), 'string(v:val)')

"===================================
"=== VIM-Plug ======================
"===================================
call plug#begin('~/.vim/plugged')
Plug 'lyokha/vim-xkbswitch'                 "neovim notsupport
Plug 'grwlf/xkb-switch'                  "neoivm norsupport
Plug 'vim-airline/vim-airline'
Plug 'connorholyday/vim-snazzy'
Plug 'preservim/nerdtree'
Plug 'mbbill/undotree'
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline-themes'
Plug 'Raimondi/delimitMate'
Plug 'Chiel92/vim-autoformat'
Plug 'preservim/nerdcommenter'
Plug 'kien/rainbow_parentheses.vim'
Plug 'luochen1990/rainbow'
Plug 'godlygeek/tabular'
Plug 'mzlogin/vim-markdown-toc'
Plug 'plasticboy/vim-markdown'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
Plug 'ferrine/md-img-paste.vim' 
Plug 'lervag/vimtex'
Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'mhinz/vim-startify'
Plug 'dhruvasagar/vim-table-mode'
Plug 'vim-scripts/taglist.vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'wakatime/vim-wakatime'
Plug 'joshdick/onedark.vim'
Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'
call plug#end()

"===================================
"=== Theme =========================
"===================================
colorscheme snazzy 
"colorscheme onedark
"colorscheme molokai
"colorscheme molokai
"syntax enable
"set background=dark
"let g:solarized_termcolors=256
"colorscheme solarized
"set g:airline_solarized_bg='dark'
"Set AirlineTheme {luna}
let g:airline_theme='luna'
