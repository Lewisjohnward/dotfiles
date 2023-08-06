echom "Hello, world!"
" vi compat
set nocompatible

" filetype func off
filetype off

"set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'SirVer/ultisnips'
Plugin 'pangloss/vim-javascript'    " JavaScript support
Plugin 'leafgarland/typescript-vim' " TypeScript syntax
Plugin 'maxmellon/vim-jsx-pretty'
Plugin 'preservim/nerdtree'
Plugin 'ryanoasis/vim-devicons'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
Bundle 'sonph/onehalf', {'rtp': 'vim/'}
 set background=dark
 let g:colours_name="onehalfdark"
 let colors_name="onehalfdark"
" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
set runtimepath+=~/.vim/bundle/nerdtree

"updates source when rc is updated
"autocmd BufWritePost .vimrc source %

imap jk <Esc>
set encoding=UTF-8
set guifont=3270\ Nerd\ Font\ 11
syntax on 
set noswapfile 
set hlsearch 
set nobackup
set wrap
set linebreak
set number relativenumber
set autoindent
set expandtab
set shiftround
set shiftwidth=4
set smartindent
set smarttab
set tabstop=4

set ignorecase
set incsearch
set smartcase

set complete-=i
set lazyredraw

set display
set history=1000
set nomodeline
set shell
set showcmd



let mapleader = "\<Space>"




"####################### COC #######################
" COC pairs :CocInstall coc-pairs
" COC Snippets
" COC coc-prettier
":CocInstall coc-prettier

"prettier
command! -nargs=0 Prettier :CocCommand prettier.forceFormatDocument

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif


" Tab completion
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Tab previous completion
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" CR to accept selection completion item
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)


" Goto code naviagtion
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

set updatetime=200
set signcolumn=yes

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" COC Snippets
" Use <C-l> for trigger snippet expand.
imap <C-l> <Plug>(coc-snippets-expand)

" Use <C-j> for select text for visual placeholder of snippet.
vmap <C-j> <Plug>(coc-snippets-select)

" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

" Use <C-j> for both expand and jump (make expand higher priority.)
imap <C-j> <Plug>(coc-snippets-expand-jump)

" Use <leader>x for convert visual selected code to snippet
xmap <leader>x  <Plug>(coc-convert-snippet)

" View snippets
nnoremap <c-s> :CocCommand snippets.editSnippets<cr>
" view coc config
nnoremap <c-c> :CocConfig<cr>


"##############################################




hi NormalColor guifg=Black guibg=green ctermbg=28 ctermfg=0
hi InsertColor guifg=Black guibg=Cyan ctermbg=37 ctermfg=0
hi ReplaceColor guifg=Black guibg=maroon1 ctermbg=161 ctermfg=0
hi VisualColor guifg=Black guibg=Orange ctermbg=178 ctermfg=0

set laststatus=2
set statusline=

"set statusline+=%#PmenuSel#
set statusline+=%#LineNr#
set statusline+=%{resolve(expand('%:p'))} 
"set statusline+=%#PmenuSel#
set statusline+=%=
"set statusline+=%#CursorColumn#
"set statusline+=%#PmenuSel#
set statusline+=\ %y
set statusline+=\ %{&fileencoding?&fileencoding:&encoding}
set statusline+=\ [%{&fileformat}\]
set statusline+=\ %p%%
set statusline+=\ %l:%c
set statusline+=\ %p%%
"set statusline+=\ 
set statusline+=%#NormalColor#%{(mode()=='n')?'\ \NORMAL\ ':''}
set statusline+=%#InsertColor#%{(mode()=='i')?'\ \INSERT\ ':''}
set statusline+=%#ReplaceColor#%{(mode()=='R')?'\ \REPLACE\ ':''}
set statusline+=%#VisualColor#%{(mode()=='v')?'\ \VISUAL\ ':''}

"https://www.ditig.com/256-colors-cheat-sheet





"folds
autocmd BufWinleave *.* mkview
autocmd BufWinEnter *.* silent loadview

"close all buffers except current
nnoremap <leader>bco :call CloseAll()<CR>
command! BufCur execute '%bdelete|edit #|normal `"'
function CloseAll()
    NERDTreeFocus
    let cwd = getcwd()
    echom cwd
    :exe "normal \<c-w>p"
    BufCur
    execute "NERDTree". cwd
    :exe "normal \<c-w>p"
endfunction


"edit i3 config file
noremap <leader>i3 :e ~/.config/i3/config<CR>
"Enable auto completion menu after pressing TAB.
set wildmenu

" Make wildmenu behave like similar to Bash completion.
set wildmode=list:longest

" There are certain files that we would never want to edit with Vim.
" Wildmenu will ignore files with these extensions.
set wildignore=*.docx,*.jpg,*.png,*.gif,*.pdf,*.pyc,*.exe,*.flv,*.img,*.xlsx

"autocmd VimEnter * NERDTree
autocmd VimEnter * set showcmd
"on vimEnter keeps current pane 
autocmd VimEnter * wincmd p
" If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
    \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
"set newly opened buffer to dir file is in
autocmd BufEnter * silent! lcd %:p:h

noremap <leader>a; :q<CR>:q<CR>:q<CR>:q<CR>:q<CR>

noremap <leader>sh :!bash<CR>
"list current files
noremap <leader>ls :ls<CR>
"close current pane
map <leader>pcc <c-w>c
"naviate buffers
map <leader>q :bprev<CR>
map <leader>w :bnext<CR>
"Console.log
map <leader>cl iconsole.log()<ESC>ha
map <leader>log yiwoconsole.log(<ESC>pa)<ESC>:w<CR>
"update rc
map <leader>rcu :w<CR> :source ~/.vimrc<CR>
"insert onclick
map <leader>roc i onClick={() => function() }
"add border
noremap <leader>border oborder: 1px solid black;
"navigate panes
map <c-h> <c-w>h
map <c-j> <c-w>j
map <c-k> <c-w>k
map <c-l> <c-w>l
" close pane
nnoremap <leader>cw <C-w>c
noremap <leader>vw <C-w>v
"run current file with node
map <leader>nr :!node <c-r>% <CR>
"Close current buffer 
map <leader>bcc :bp<bar>sp<bar>bn<bar>bd<CR>

"Force close current buffer
"map <leader>bfc :bd!
"Close all buffers"
map <leader>bca :%bd<CR>
"Edit rc
"map <leader>rce :e ~/.vimrc<CR>
map <leader>hh :noh<CR>
"Save current file
map <leader><space> :w<CR>
"Close nerd tree
map <leader>cn :NERDTree<CR> :q<CR>
"Goto nerdTree
nnoremap <leader>rn :NERDTreeRefresh<CR>
map <c-n> :NERDTreeFocus<CR>

"inoremap<c-b> <Esc>:NERDTreeToggle<cr>
"nnoremap<c-b> <Esc>:NERDTreeToggle<cr>

map <leader>isc @p
map <leader>exsc :%s/const/export const/g<CR>
"insert React useEffect
nnoremap <leader>rue @j
"insert component from name of file
map <leader>ric @i
"turn variable into state React
map <leader>ris @o
"import react useEffect & useState
map <leader>riueus @l<c-o>

"turn word into a prop react
map <leader>rcp @f

"Delete current line then paste it below
nnoremap - ddp
"Delete current line and move up
nnoremap _ ddkP
"Delete current line in insert mode
inoremap <c-d> <esc>ddi
"
"Capitalise highlighted
vnoremap <c-u> ~

set splitright
" Open cheatsheets
nnoremap <leader>csqt :e ~/cheatsheets/qtcheatsheet.py<cr>
nnoremap <leader>cspy :e ~/cheatsheets/pythoncheatsheet.py<cr>
nnoremap <leader>csc :e ~/cheatsheets/ccheatsheet.c<cr>
nnoremap <leader>csbash :e ~/cheatsheets/bashcheatsheet.sh<cr>
nnoremap <leader>cswd :e ~/cheatsheets/webdev.js<cr>


nnoremap <leader>ffp :Files ~/programming/<CR>
nnoremap <leader>ffa :Files ~<CR>
nnoremap <leader>ffb :Buffers<CR>
"turn word into a prop
let @f = 'yiwA={"}jkB'

"import useState and useEffect from react
let @l = 'ggOimport {useState, useEffect} from "react"jk'
"create state from word
let @o = 'Iconst [jkA, jkbbyiwAset"jkF llll~A] = useSa€kbtate(null)jkkjj'
"exports styles
let @p = 'iimport styled from "styled-como€kbponents"0€kbjk0'
"CREATES CSS FOR GRID
let @y = 'idisplay: grid;j€kbgrid-template-columns;grid-template-rows;grid-gap:justify-content: center;align-items: center;jkkka 5px;jkjkklllla: repear€kbt(4€kb2, 1fr)jkki repeat(2, 1fr)jk5j'


"Print hello world
"echom prints 
":call HelloWorld()
function HelloWorld()
    echom "Hello, world!"
endfunction

"echom ReturnTest()
function ReturnTest()
    return "This is a simple function to return"
endfunction

function TextwidthIsTooWide()
    if &l:textwidth >#80
        return 1
    endif
endfunction

function Increase_Screen()
    execute 'increase current window height 4 lines'
endfunction



"opens rc in v split
"function EditRc()
"    execute "rightbelow vsplit " . "~/.vimrc"
"endfunction

"map <leader>rce :call EditRc()<cr>
"function EditRc()
"    execute "rightbelow vsplit " . "~/.vimrc"
"endfunction

nnoremap <leader>rce :e ~/.vimrc<cr>

"when writing vimscripts always use normal! and never normal you cant trust
"users will have mapped

map <leader>test :call Test()<cr>
"inserts test
function Test()
    normal! itest
endfunction

map <leader>rcc :call React_Create_Component()<cr>
function React_Create_Component()
    "get current line number
    let currentLine = line(".")
    "if currentLine = 0 push down 
    if currentLine == 1
        execute "normal! i\<CR>\<CR>"
    endif
    let fileName = expand('%:t')
    let max = "normal! i" . fileName . "\<esc>Iexport const \<esc>w~A = () => {}\<esc>"
    "let max = "normal! i" .filename . "\<esc>Iexport const \<esc>w~A = () => {}\<esc>"
    let max .= "i\<CR>\<esc>Oreturn ()\<esc>i\<CR><div>\<CR>" . fileName . "\<CR></div>"
    let max .= "\<CR>"
    "remove .js
    let removejs = "%s/.js//g"
    execute max
    execute removejs
endfunction

nnoremap <leader>ind gg=G``zz
nnoremap <leader>be :e ~/.bashrc<CR>

nnoremap <leader>cm I//<esc>
nnoremap <leader>ucm ^xx
"comment uncomment jsx"
nnoremap <leader>xc = @j
nnoremap <leader>xuc = @k
let @j =  '^i{/*jkA*/}jk^'
let @k = '^%x``x$xx^xx'

" screen size change small large 
nnoremap <leader>eql <c-w>=
nnoremap <leader>small :exe "vertical resize 25"<CR>
nnoremap <leader>large :exe "vertical resize 80"<CR>

"tailwind
ab clg console.log()
ab cN className=""
ab &_* [&_*]:
ab &>* [&>*]:
ab hv hover:
ab ac active:
ab bgr bg-red-200
ab bgb bg-blue-200
ab bgw bg-white
ab bdr border border-black
ab rdd rounded
"to get ^m c-v CR

"Creates arrow function
nnoremap <leader>af @o<cr><esc>O
let @o = '^iconst jkA = () => {}jki'

"react prop create
nnoremap <leader>rpc  @p
let @p = "yiwea={jka\<c-r>\"}jkB"

"react create use state
nnoremap <leader>rus @m
let @m = "yiwiconst [jkA, set\<c-r>\"jkBftl~jkA] = useState(\"\")"


" NERDTrees File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
 exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
 exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('tsx', 'lightblue', 'none', '#3252a8', '#3252a8')
call NERDTreeHighlightFile('ts', 'blue', 'none', '#3252a8', '#3252a8')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'yellow', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('ds_store', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('gitconfig', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('bashrc', 'Gray', 'none', '#686868', '#151515')
call NERDTreeHighlightFile('bashprofile', 'Gray', 'none', '#686868', '#151515')

