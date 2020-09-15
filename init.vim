let mapleader =","

if ! filereadable(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim"'))
	echo "Downloading junegunn/vim-plug to manage plugins..."
	silent !mkdir -p ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/
	silent !curl "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim" > ${XDG_CONFIG_HOME:-$HOME/.config}/nvim/autoload/plug.vim
	autocmd VimEnter * PlugInstall
endif

call plug#begin(system('echo -n "${XDG_CONFIG_HOME:-$HOME/.config}/nvim/plugged"'))
Plug 'morhetz/gruvbox'
Plug 'tpope/vim-surround'
Plug 'preservim/nerdtree'
Plug 'junegunn/goyo.vim'
Plug 'PotatoesMaster/i3-vim-syntax'
Plug 'jreybert/vimagit'
Plug 'lukesmithxyz/vimling'
Plug 'vimwiki/vimwiki'
Plug 'bling/vim-airline'
Plug 'tpope/vim-commentary'
Plug 'kovetskiy/sxhkd-vim'
Plug 'ap/vim-css-color'
call plug#end()

set go=a
set mouse=a
set hlsearch
set nowrap
set clipboard+=unnamedplus
colorscheme gruvbox

" Some basics:
	set nocompatible
	filetype plugin on
	syntax on
	set encoding=utf-8
	set number relativenumber


" Shortcut to use blackhole register by default
"	nnoremap d "_d
"	vnoremap d "_d
"	nnoremap D "_D
"	vnoremap D "_D
	nnoremap c "_c
	vnoremap c "_c
"	nnoremap C "_C
"	vnoremap C "_C
"	nnoremap x "_x
"	vnoremap x "_x
"	nnoremap X "_X
"	vnoremap X "_X

" Shortcut to use clipboard with <leader>
"	nnoremap <leader>d d
"	vnoremap <leader>d d
"	nnoremap <leader>D D
"	vnoremap <leader>D D
	nnoremap <leader>c c
	vnoremap <leader>c c
"	nnoremap <leader>C C
"	vnoremap <leader>C C
"	nnoremap <leader>x x
"	vnoremap <leader>x x
"	nnoremap <leader>X X
"	vnoremap <leader>X X

" Enable autocompletion:
	set wildmode=longest,list,full

" Disables automatic commenting on newline:
	autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

" Goyo plugin makes text more readable when writing prose:
	map <leader>f :Goyo \| set bg=light \| set linebreak<CR>

" Spell-check set to <leader>o, 'o' for 'orthography':
	map <leader>o :setlocal spell! spelllang=en_us<CR>

" Splits open at the bottom and right, which is non-retarded, unlike vim defaults.
	set splitbelow splitright

" Nerd tree
	map <leader>n :NERDTreeToggle<CR>
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
    if has('nvim')
        let NERDTreeBookmarksFile = stdpath('data') . '/NERDTreeBookmarks'
    else
        let NERDTreeBookmarksFile = '~/.vim' . '/NERDTreeBookmarks'
    endif

" vimling:
	nm <leader>d :call ToggleDeadKeys()<CR>
	imap <leader>d <esc>:call ToggleDeadKeys()<CR>a
	nm <leader>i :call ToggleIPA()<CR>
	imap <leader>i <esc>:call ToggleIPA()<CR>a
	nm <leader>q :call ToggleProse()<CR>

" Shortcutting split navigation, saving a keypress:
	map <C-h> <C-w>h
	map <C-j> <C-w>j
	map <C-k> <C-w>k
	map <C-l> <C-w>l

" Replace ex mode with gq
"	map Q gq

" Check file in shellcheck:
"	map <leader>s :!clear && shellcheck %<CR>

" Open my bibliography file in split
"	map <leader>b :vsp<space>$BIB<CR>
"	map <leader>r :vsp<space>$REFER<CR>

" Replace all is aliased to S.
	nnoremap S :%s//g<Left><Left>

" Compile document, be it groff/LaTeX/markdown/etc.
"	map <leader>c :w! \| !compiler <c-r>%<CR>

" Open corresponding .pdf/.html or preview
"	map <leader>p :!opout <c-r>%<CR><CR>

" Runs a script that cleans out tex build files whenever I close out of a .tex file.
	autocmd VimLeave *.tex !texclear %

" Ensure files are read as what I want:
	let g:vimwiki_ext2syntax = {'.Rmd': 'markdown', '.rmd': 'markdown','.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
	map <leader>v :VimwikiIndex
	let g:vimwiki_list = [{'path': '~/vimwiki', 'syntax': 'markdown', 'ext': '.md'}]
	autocmd BufRead,BufNewFile /tmp/calcurse*,~/.calcurse/notes/* set filetype=markdown
	autocmd BufRead,BufNewFile *.ms,*.me,*.mom,*.man set filetype=groff
	autocmd BufRead,BufNewFile *.tex set filetype=tex

" Save file as sudo on files that require root permission
	cnoremap w!! execute 'silent! write !sudo tee % >/dev/null' <bar> edit!

" Enable Goyo by default for mutt writing
	autocmd BufRead,BufNewFile /tmp/neomutt* let g:goyo_width=80
	autocmd BufRead,BufNewFile /tmp/neomutt* :Goyo | set bg=light
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZZ :Goyo\|x!<CR>
	autocmd BufRead,BufNewFile /tmp/neomutt* map ZQ :Goyo\|q!<CR>

" Automatically deletes all trailing whitespace and newlines at end of file on save.
	autocmd BufWritePre * %s/\s\+$//e
	autocmd BufWritepre * %s/\n\+\%$//e

" When shortcut files are updated, renew bash and ranger configs with new material:
	autocmd BufWritePost files,directories !shortcuts
" Run xrdb whenever Xdefaults or Xresources are updated.
	autocmd BufWritePost *Xresources,*Xdefaults !xrdb %
" Update binds when sxhkdrc is updated.
	autocmd BufWritePost *sxhkdrc !pkill -USR1 sxhkd

" Turns off highlighting on the bits of code that are changed, so the line that is changed is highlighted but the actual text that has changed stands out on the line and is readable.
if &diff
    highlight! link DiffText MatchParen
endif

" Ctrl-s to save in both normal mode and insert mode.
" According to me it's a real lifesaver.
nnoremap <C-s> :update<CR>
inoremap <C-s> <ESC>:update<CR>i

" Gives space around the cursor when scrolling.
set scrolloff=10

" Clear search highlights
nnoremap <esc><esc> :noh<enter>

highlight LineNr ctermbg=black

" Show 80th line
set colorcolumn=80

" These commands are only enabled for python files.
augroup python
    " Ctrl-g now lets you write a grep command to search all python files.
    nnoremap <C-g> <ESC>:copen <BAR> grep  *.py<LEFT><LEFT><LEFT><LEFT><LEFT>

    " TIP: To work even more effectively, try running the ':copen' command
    " after pressing <F5> and the program didn't run. It's pretty cool!
    " (':cn' and ':cp' will help you here!)
    "
    " Say that we're using python scripts here.
    set makeprg=python3
    " Jumps you to the errors, it's pretty speedy.
    compiler pyunit
    " Save and run the python script with <F5>, it's pretty cool.
    nnoremap <F5> :w <BAR> :make %<CR>
    " Make sure Vim gets the memo about syntax.
    set syntax=python
augroup END

" Keep the undo history, lets you close the buffer and
" still undo.
if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/undo-dir")
    call mkdir($HOME."/.vim/undo-dir", "", 0700)
endif
set undodir=~/.vim/undo-dir
set undofile

" Map keys to y/p to/from PRIMARY and CLIPBOARD
noremap <Leader>Y "*y
noremap <Leader>P "*y

noremap <Leader>y "+y
noremap <Leader>p "+p
