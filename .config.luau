const luau_config = {
	languagemode = `strict`,

	aliases = {
		std = "~/.lute/typedefs/1.0.1/std",
		vendor = "vendor",
		src = "src",
		tests = "tests",
	},

	lint = {
		[`*`] = true,
	},
}

return {
	luau = luau_config,
}
