return {
	"rmagatti/auto-session",
	config = function()
		local auto_session = require("auto-session")

		auto_session.setup({
			auto_restore_enabled = false,
			auto_save_enabled = true,
			auto_save_interval = 30000,
			auto_session_suppress_dirs = { "~/" },
		})
	end,
}
