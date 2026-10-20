const luninjau = require("@src")
const fs = require("@std/fs")
const json = require("@vendor/json")
const path = require("@std/path")
const test = require("@std/test")
const stringdiff = require("@vendor/stringdiff")

test.suite("golden file tests", function(suite)
	const dirs = fs.listDirectory("tests/samples")

	for _, entry in dirs do
		if entry.type ~= "dir" then
			continue
		end

		const ast_loc = path.join("tests/samples", entry.name, "ast.json")
		const expected_loc = path.join("tests/samples", entry.name, "expected.ninja")

		suite:case(entry.name, function(asserts)
			const expected = fs.readFileToString(expected_loc)
			const got = luninjau.print_file(json.deserialize(fs.readFileToString(ast_loc)) :: any)

			if expected ~= got then
				print("running")
				const diffs = stringdiff.find_diffs(expected, got)
				for _, difference in diffs do
					if difference.actionType == stringdiff.action_types.Delete then
						print(
							`deletion: {difference.value}, codes: {table.concat(
								{ string.byte(difference.value, 1, #difference.value) },
								", "
							)}`
						)
					elseif difference.actionType == stringdiff.action_types.Insert then
						print(
							`insert: {difference.value}, codes: {table.concat(
								{ string.byte(difference.value, 1, #difference.value) },
								", "
							)}`
						)
					end
				end
				print(#diffs)
			end

			asserts.eq(expected, got)
		end)
	end
end)
