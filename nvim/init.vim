set t_Co=256
vind29
:
syntax on
set mouse=a
set number
set hidden
set showcmd
set tabstop=4
colorscheme elflord

if has('unnamedplus')
	set clipboard=unnamedplus
else
	set clipboard=unnamed
endif

filetype plugin indent on

func! Chomp(string)
    return substitute(a:string, '\n\+$', '', '')
endfunc

func! DeleteTrailingWhitespace()
  exe "normal mz"
  %s/\s\+$//ge
  exe "normal `z"
endfunc

command DeleteWhiteSpace execute DeleteTrailingWhitespace()

cmap w!! w !su -c "tee > /dev/null %"

let s:editor_root=expand('~/.nvim')

let vundle_installed=1
let vundle_readme=s:editor_root . '/bundle/vundle/README.md'

if !filereadable(vundle_readme)
	echo "Installing Vundle.."
	echo ""
	" silent execute "! mkdir -p ~/." . s:editor_path_name . "/bundle"
	silent call mkdir(s:editor_root . '/bundle', "p")
	silent execute "!git clone https://github.com/gmarik/vundle " . s:editor_root . "/bundle/vundle"
	let vundle_installed=0
endif

let &rtp = &rtp . ',' . s:editor_root . '/bundle/vundle/'
call vundle#rc(s:editor_root . '/bundle')

Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'vim-scripts/indentpython.vim'
Plugin 'Shougo/deoplete.nvim'
Plugin 'rust-lang/rust.vim'
Plugin 'sebastianmarkow/deoplete-rust'
Plugin 'zchee/deoplete-clang'
Plugin 'artur-shaik/vim-javacomplete2'

if vundle_installed == 0
	echo "installing"
	:PluginInstall
endif

" deoplete config
let g:deoplete#enable_at_startup = 1

" rust config
let g:deoplete#sources#rust#racer_binary=Chomp(system('which racer'))
let g:deoplete#sources#rust#rust_source_path=Chomp(system('realpath $(rustup run nightly rustc --print sysroot)/lib/rustlib/src/rust/src'))

let g:rustfmt_autosave = 1
let g:rustfmt_command = 'rustfmt'

" clang config
let g:deoplete#sources#clang#libclang_path = '/lib/libclang.so'
let g:deoplete#sources#clang#clang_header = '/lib/clang'


" glorious readline
cnoremap <C-a> <Home>
cnoremap <C-e> <End>
cnoremap <C-p> <Up>
cnoremap <C-n> <Down>
cnoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <M-b> <S-Left>
cnoremap <M-f> <S-Right>

" save me from terminal mode
" tnoremap <Esc> <C-\><C-n>
