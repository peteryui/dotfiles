" ~/.vimrc
" Vim is the quick editor here: fast review, small edits, fast keyword search.
" IntelliJ is the project IDE, so this file stays plugin-free and instant.

set nocompatible

" Load filetype + syntax machinery first so our autocmds below win over the
" bundled ftplugins.
filetype plugin indent on
syntax enable

" ---------------------------------------------------------------- Appearance
set background=dark
let g:solarized_termtrans=1     " Keep the terminal's own background
let g:solarized_termcolors=256  " Approximate Solarized in a non-Solarized palette
silent! colorscheme solarized

set number                      " Line numbers
if exists("&relativenumber")
	set relativenumber          " ...relative to the cursor, for fast j/k jumps
endif
set cursorline                  " Highlight the current line
set ruler                       " Show the cursor position
set showcmd                     " Show the (partial) command as it's typed
set showmode                    " Show the current mode
set title                       " Show the filename in the window titlebar
set laststatus=2                " Always show the status line
set statusline=%<%f\ %h%m%r%=%y\ \ %-12.(%l,%c%V%)\ %P
set scrolloff=3                 " Start scrolling three lines from the border
set sidescroll=1
set sidescrolloff=5
set nowrap                      " Long lines scroll instead of wrapping (,w toggles)
set shortmess+=aIc              " Trim messages; no intro screen
set noerrorbells
set novisualbell
set belloff=all

" Show “invisible” characters (eol left out — it's just noise while reviewing)
set listchars=tab:▸\ ,trail:·,nbsp:␣,extends:›,precedes:‹
set list

" ----------------------------------------------------------------- Behaviour
set encoding=utf-8 nobomb
set clipboard=unnamed           " Use the macOS clipboard by default
set backspace=indent,eol,start  " Allow backspace in insert mode
set hidden                      " Switch buffers without saving first
set autoread                    " Reload files changed outside Vim (e.g. IntelliJ)
set splitbelow
set splitright
set mouse=a                     " Mouse in all modes (,m toggles for terminal copy)
set nostartofline               " Don't jump to column 1 when moving around
set modeline
set modelines=4
set nrformats-=octal            " Don't treat 007 as octal for <C-a>/<C-x>
set history=1000
set viminfo='100,<50,s10,h      " Cap viminfo so startup stays instant
set secure                      " (`exrc` deliberately left off — see README notes)
let mapleader=","

" Command-line completion
set wildmenu
set wildmode=longest:full,full
set wildignorecase
set wildignore+=*/.git/*,*/node_modules/*,*/target/*,*/.venv/*,*/venv/*
set wildignore+=*/__pycache__/*,*/tmp/*,*/dist/*,*/build/*,*.pyc,*.o,*.class,*.DS_Store

" ---------------------------------------------------------------- Performance
set synmaxcol=300               " Don't syntax-highlight absurdly long lines
set redrawtime=1500             " Give up on slow syntax rather than hanging
set lazyredraw                  " Don't redraw mid-macro
set ttimeout
set ttimeoutlen=10              " Esc responds instantly
set updatetime=500

" ------------------------------------------------- Backups, swaps, undo files
for s:dir in ['backups', 'swaps', 'undo']
	if !isdirectory($HOME . '/.vim/' . s:dir)
		call mkdir($HOME . '/.vim/' . s:dir, 'p', 0700)
	endif
endfor
set backupdir=~/.vim/backups//
set directory=~/.vim/swaps//
if exists("&undodir")
	set undodir=~/.vim/undo//
	set undofile                " Persistent undo across sessions
endif
set backupskip=/tmp/*,/private/tmp/*

" -------------------------------------------------------------- Search & grep
set hlsearch
set incsearch
set ignorecase
set smartcase                   " ...but respect case when the pattern has any

if executable('rg')
	set grepprg=rg\ --vimgrep\ --smart-case\ --hidden\ --glob\ '!.git/*'
	set grepformat=%f:%l:%c:%m
endif
command! -nargs=+ -complete=file_in_path Rg
	\ silent! grep! <args> | redraw! | botright cwindow

" `gf` / `:find` across the tree (wildignore keeps it from crawling junk)
set path=.,,**

" fzf ships a tiny built-in Vim plugin — no plugin manager needed
for s:fzf in ['/opt/homebrew/opt/fzf', '/usr/local/opt/fzf']
	if isdirectory(s:fzf)
		execute 'set runtimepath+=' . s:fzf
		break
	endif
endfor
if executable('fd')
	let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --follow --exclude .git'
endif

" -------------------------------------------------------------- File browsing
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_altv = 1

" -------------------------------------------------------------- Indentation
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set autoindent
set smarttab

" Match the file you're editing rather than imposing our defaults on it —
" the main hazard of using Vim for quick edits inside someone else's repo.
function! s:SniffIndent() abort
	if &l:binary || &l:buftype !=# '' || line('$') < 5 || line('$') > 20000
		return
	endif
	let l:tabs = 0
	let l:spaces = []
	for l:line in getline(1, min([300, line('$')]))
		if l:line =~# '^\t'
			let l:tabs += 1
		elseif l:line =~# '^ \{2,}\S'
			call add(l:spaces, strlen(matchstr(l:line, '^ *')))
		endif
	endfor
	if l:tabs > len(l:spaces)
		setlocal noexpandtab
	elseif len(l:spaces) > 0
		let l:width = min(l:spaces)
		if index([2, 4, 8], l:width) >= 0
			let &l:shiftwidth = l:width
			let &l:softtabstop = l:width
		endif
		setlocal expandtab
	endif
endfunction

" ------------------------------------------------------------------ Functions
" Strip trailing whitespace (,ss)
function! StripWhitespace()
	let save_cursor = getpos(".")
	let old_query = getreg('/')
	:%s/\s\+$//e
	call setpos('.', save_cursor)
	call setreg('/', old_query)
endfunction

" ------------------------------------------------------------------- Mappings
noremap <leader>ss :call StripWhitespace()<CR>
" Save a file as root (,W)
noremap <leader>W :w !sudo tee % > /dev/null<CR>
" Clear search highlight
nnoremap <silent> <leader><space> :nohlsearch<CR>
" Fuzzy-find a file / pick a buffer
nnoremap <leader>f :FZF<CR>
nnoremap <leader>b :buffers<CR>:buffer<Space>
" Grep the tree; ,k greps the word under the cursor
nnoremap <leader>g :Rg<Space>
nnoremap <leader>k :Rg <C-r><C-w><CR>
" Quickfix hopping
nnoremap ]q :cnext<CR>
nnoremap [q :cprevious<CR>
" Toggle wrap / mouse (mouse off = terminal text selection works again)
nnoremap <leader>w :setlocal wrap!<CR>:setlocal wrap?<CR>
nnoremap <leader>m :let &mouse = (&mouse ==# 'a' ? '' : 'a')<Bar>echo 'mouse=' . &mouse<CR>
" Keep the selection after shifting
xnoremap < <gv
xnoremap > >gv

" ----------------------------------------------------------- Automatic things
augroup vimrc
	autocmd!

	" Don't let huge files (logs, dumps) bog Vim down
	autocmd BufReadPre * if getfsize(expand('<afile>')) > 5 * 1024 * 1024
		\ | setlocal noswapfile noundofile nobackup bufhidden=unload | endif
	autocmd BufWinEnter * if line2byte(line('$') + 1) > 5 * 1024 * 1024
		\ | setlocal nocursorline norelativenumber nolist synmaxcol=128 | endif

	" Adopt the file's existing indentation
	autocmd BufReadPost * call s:SniffIndent()

	" Reopen a file where you left it
	autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
		\ | execute "normal! g`\"" | endif

	" Notice edits made by IntelliJ (or anything else) while Vim is open
	autocmd FocusGained,BufEnter,CursorHold * silent! checktime

	" Per-filetype tweaks
	autocmd FileType make,go setlocal noexpandtab
	autocmd FileType python,rust setlocal shiftwidth=4 softtabstop=4
	autocmd FileType gitcommit setlocal spell textwidth=72 nolist colorcolumn=73
	autocmd FileType markdown,text setlocal wrap linebreak nolist
augroup END
