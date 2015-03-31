return setmetatable(
	{
        _NAME = "awesome_config"
    },
	{
        __index = function(table, key)
		    local module = rawget(table, key)
		    return module or require(table._NAME .. '.' .. key)
        end
    }
)