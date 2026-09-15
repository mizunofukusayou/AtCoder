vim.g.mapleader = " "

local snacks = require("snacks")

local root = vim.env.ROOT
if not root or root == "" then
	vim.notify("環境変数 ROOT が設定されていません。", vim.log.levels.ERROR, { title = "Config Error" })
	root = nil
elseif vim.fn.isdirectory(root) ~= 1 then
	vim.notify("ROOT の実体が存在しません: " .. root, vim.log.levels.ERROR, { title = "Config Error" })
	root = nil
end

-- このディレクトリ内での files 検索のデフォルト挙動を上書き
snacks.config.picker = snacks.config.picker or {}
snacks.config.picker.sources = snacks.config.picker.sources or {}
snacks.config.picker.sources.files = vim.tbl_deep_extend("force", snacks.config.picker.sources.files or {}, {
	ignored = true, -- .gitignore された a.cpp などを表示
	hidden = true, -- .git, .direnv などのドットファイルを表示
	exclude = {
		".DS_Store",
		".direnv",
		".envrc",
		".gitignore",
		".gitmodules",
		".include",
		".vscode",
		"README.md",
		"a.out",
		"a.out.dSYM",
		"docs",
		"flake.lock",
		"input.txt",
		"library",
	},
})

local function run_cpp(update_input)
	vim.cmd("update")

	if update_input then
		local input = vim.fn.getreg("+")
		local f = io.open("input.txt", "w")
		if f then
			f:write(input)
			f:close()
		end
	end

	local cmd
	local file = vim.fn.expand("%:p")

	if vim.fn.getftime(root .. "/a.out") >= vim.fn.getftime(file) then
		cmd = "./a.out < input.txt"
	else
		local flags = {
			"-std=gnu++23",
			"-fsanitize=undefined,address", -- 未定義動作・メモリ不正アクセスの検知
			"-fno-sanitize-recover=all", -- サニタイザエラー発生時に即座に停止
			"-fcolor-diagnostics", -- エラー・警告メッセージの色分け表示
			"-fansi-escape-codes",
			"-Wall", -- 基本的な警告を有効化
			"-Wextra", -- 追加の警告を有効化
			"-Wshadow", -- 変数のシャドウイングを警告
			"-Wno-unused-const-variable", -- 未使用const変数の警告無視
			"-g", -- デバッグ情報を付与
			"-oa.out",
		}
		cmd = string.format("clang++ %s %s && ./a.out < input.txt", table.concat(flags, " "), vim.fn.shellescape(file))
	end

	Snacks.terminal.open(cmd, {
		cwd = root,
		auto_close = false,
	})
end

-- クリップボードから input.txt を更新して実行
vim.keymap.set("n", "<leader>jj", function()
	run_cpp(true)
end, { desc = "Run C++ with updating input.txt" })

-- 既存の input.txt でそのまま実行
vim.keymap.set("n", "<leader>jk", function()
	run_cpp(false)
end, { desc = "Run C++ with existing input.txt" })

-- <leader>fl で library 走査
vim.keymap.set("n", "<leader>fl", function()
	snacks.picker.files({
		cwd = root .. "/library",
		hidden = false,
	})
end, { desc = "Find Library Files" })

-- <leader>ti でファイルを初期化
vim.keymap.set("n", "<leader>ti", function()
	local tmpl = vim.fn.expand(root .. "/tmpl.cpp")
	if vim.fn.filereadable(tmpl) == 1 then
		local lines = vim.fn.readfile(tmpl)
		vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
		vim.cmd("update")
		vim.fn.cursor(1, 1)
		vim.fn.search([[void\s\+solve]])
		vim.cmd(vim.api.nvim_replace_termcodes("normal! f{", true, false, true))
	else
		vim.notify("テンプレートファイルが見つかりません: " .. tmpl, vim.log.levels.WARN)
	end
end, { desc = "Init cpp file" })

-- <leader>kk でコードをコピー
vim.keymap.set("n", "<leader>kk", "<cmd>%yank +<CR>", { desc = "Copy file" })
