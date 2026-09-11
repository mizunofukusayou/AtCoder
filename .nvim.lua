vim.g.mapleader = " "

local function run_cpp(update_input)
	vim.cmd("write")

	if update_input then
		local input = vim.fn.getreg("+")
		local f = io.open("input.txt", "w")
		if f then
			f:write(input)
			f:close()
		end
	end

	local flags = {
		"-isystem.include",
		"-std=gnu++23",
		"-fsanitize=undefined,address", -- 未定義動作・メモリ不正アクセスの検知
		"-fno-sanitize-recover=all", -- サニタイザエラー発生時に即座に停止
		"-fcolor-diagnostics", -- エラー・警告メッセージの色分け表示
		"-fansi-escape-codes",
		"-Wall", -- 基本的な警告を有効化
		"-Wextra", -- 追加の警告を有効化
		"-Wshadow", -- 変数のシャドウイングを警告
		"-Wno-unused-const-variable", -- 未使用const変数の警告無視
		"-Wno-unqualified-std-cast-call", -- std::move/forward修飾警告の無視(ACL対策)
		"-g", -- デバッグ情報を付与
		"-oa.out",
	}

	local file = vim.fn.expand("%")
	local cmd =
		string.format("clang++ %s %s && ./a.out < input.txt", table.concat(flags, " "), vim.fn.shellescape(file))
	-- vim.cmd("botright 12split | terminal " .. cmd)
	Snacks.terminal.open(cmd, {
		cwd = vim.fn.expand("%:p:h"), -- 編集中のファイルがあるディレクトリ
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
