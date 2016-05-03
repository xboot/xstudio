return {
	EventDispatcher = {
		childs = {
			addEventListener = {
				args = "(type, listener [, data])",
				description = "Registers a listener function",
				returns = "()",
				type = "method"
			},
			dispatchEvent = {
				args = "(event)",
				description = "Dispatches an event",
				returns = "()",
				type = "method"
			},
			hasEventListener = {
				args = "(type)",
				description = "Checks if the EventDispatcher object has a event listener",
				returns = "()",
				type = "method"
			},
			new = {
				args = "()",
				description = "Creates a new EventDispatcher object",
				returns = "()",
				type = "function"
			},
			removeEventListener = {
				args = "(type, listener, data)",
				description = "Removes a listener function",
				returns = "()",
				type = "method"
			}
		},
	type = "class"
	},
}
