set t_Co=256
syntax on
set mouse=a
set number
set hidden
set showcmd

if has('unnamedplus')
set clipboard=unnamedplus
else
set clipboard=unnamed
endif


let s:editor_root=expand("~/.nvim")

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
	Bundle 'scrooloose/nerdtree'
	"Bundle 'scrooloose/syntastic'
	Bundle 'Valloric/YouCompleteMe'
if vundle_installed == 0
	echo "installing"
	:BundleInstall
endif


"let g:syntastic_check_on_open = 1
"let g:syntastic_python_checkers = ['pylint']
"let g:syntastic_javascript_checkers = ['jshint']



nmap <ESC>t :NERDTreeToggle<CR>
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_global_ycm_extra_conf = '~/.vim/bundle/YouCompleteMe/cpp/ycm/.ycm_extra_conf.py'
