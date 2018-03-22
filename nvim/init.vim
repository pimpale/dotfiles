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
	Bundle 'altercation/vim-colors-solarized'
if vundle_installed == 0
	echo "installing"
	:BundleInstall
endif


colorscheme elflord 


nmap <ESC>t :NERDTreeToggle<CR>
let g:ycm_server_keep_logfiles = 1
let g:ycm_server_log_level = 'debug'
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'



"
" YouCompleteMe options
"

let g:ycm_register_as_syntastic_checker = 1 "default 1
let g:Show_diagnostics_ui = 1 "default 1

"will put icons in Vim's gutter on lines that have a diagnostic set.
"Turning this off will also turn off the YcmErrorLine and YcmWarningLine
"highlighting
let g:ycm_enable_diagnostic_signs = 1
let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_always_populate_location_list = 1 "default 0
let g:ycm_open_loclist_on_ycm_diags = 1 "default 1


let g:ycm_complete_in_strings = 1 "default 1
let g:ycm_collect_identifiers_from_tags_files = 0 "default 0
let g:ycm_path_to_python_interpreter = '' "default ''


let g:ycm_server_use_vim_stdout = 0 "default 0 (logging to console)
let g:ycm_server_log_level = 'info' "default info


let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'  "where to search for .ycm_extra_conf.py if not found
let g:ycm_confirm_extra_conf = 1


let g:ycm_goto_buffer_command = 'same-buffer' "[ 'same-buffer', 'horizontal-split', 'vertical-split', 'new-tab' ]
let g:ycm_filetype_whitelist = { '*': 1 }
let g:ycm_key_invoke_completion = '<C-Space>'


nnoremap <F11> :YcmForceCompileAndDiagnostics <CR>
