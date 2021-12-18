" Aliases for capital letters
command Q q
command W w
command Wq wq
command WQ wq
command X x
command Qa qa
command Wa wa
command Wqa wqa
command WQa wqa
command Xa xa
command QA qa
command WA wa
command WQA wqa
command XA xa

" Close all buffers exept current
command! CloseBuffers normal :BufferLineCloseLeft<CR>:BufferLineCloseRight<CR>

" CMake commands
command! CMakeGenClean normal :!rm -rf Debug<CR>:!rm -rf Release<CR>:!rm compile_commands.json<CR>

command! CMakeGenDebug normal :!cmake -D CMAKE_BUILD_TYPE=Debug -D CMAKE_EXPORT_COMPILE_COMMANDS=ON -B Debug<CR>:!ln -s ./Debug/compile_commands.json compile_commands.json<CR>
command! CMakeGenRelease normal :!cmake -D CMAKE_BUILD_TYPE=Release -D CMAKE_EXPORT_COMPILE_COMMANDS=ON -B Release<CR>:!ln -s ./Release/compile_commands.json compile_commands.json<CR>

command! CMakeBuildDebug normal :!cmake --build Debug -j 8<CR>
command! CMakeBuildRelease normal :!cmake --build Release -j 8<CR>

" c/cpp commands
command! SearchFunction normal /^[a-zA-Z_][a-zA-Z_0-9*& \n]*[ \n]\+[a-zA-Z_0-9]\+[ \n]*([a-zA-Z_0-9*& \n,\[\]]*)[ \n]*{<CR>:nohlsearch<CR>
command! CopyFunctionName normal mm:SearchFunction<CR>`mN/(<CR>bye`m:nohlsearch<CR>
command! CopyStatusName normal mm:SearchFunction<CR>`mN/^ *enum[ \n]\+[a-zA-Z0-9_]\+_status[ \n]\+status[ \n]*=[ \n]*[A-Z0-9_]\+_STATUS_[A-Z0-9_]\+[ \n]*;<CR>/_status<CR>bye`m:nohlsearch<CR>

" Snippets commands
command! GetFunctionName normal :CopyFunctionName<CR>:let g:snippets_function_name = @"<CR>
command! GetStatusName   normal :CopyStatusName<CR>:let g:snippets_status_name = @"<CR>
command! GetModuleName   normal :let g:snippets_module_name
command! GetProjectName  normal :let g:snippets_project_name

