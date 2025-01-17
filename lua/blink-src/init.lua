local async = require("blink.cmp.lib.async")

local function make_item(text)
	return {
		label = text,
		kind = require("blink.cmp.types").CompletionItemKind.Class,
		insertText = text,
	}
end

local items = {
	make_item("hello this is a wip source"),
}

local source = {}

function source.new(opts)
	local self = setmetatable({}, { __index = M })
	self.opts = vim.tbl_deep_extend("keep", opts or {}, {
		insert = true,
	})
	return self
end

function source:get_completions(context, callback)
	local task = async.task.empty():map(function()
		callback({
			is_incomplete_forward = true,
			is_incomplete_backward = true,
			items = items,
		})
	end)

	return function() task:cancel() end
end

-- Plugs directly into blink's transform_items function
-- TODO: move this out of source into standalone function
function source.transform(_, items)
	return items
end

return source
