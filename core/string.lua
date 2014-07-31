-----------------------------------------------------------------------------------------
--
-- string.lua
--
-----------------------------------------------------------------------------------------
-- Author: Teddy Engel <engel.teddy[at]gmail.com> / @Teddy_Engel  
-- Copyright (c) 2013-2014 Teddy Engel                                                
-----------------------------------------------------------------------------------------
require ("core.object") -- parent class

--- Constructor ---
local function new(self, sValue)
	self:_parentConstructor(Object, sValue)

	-- Asserts
	assert(type(sValue) == 'string', 'expects a string')
end

String = class(new, Object)

function String:destroy()
	self:_parentDestructor(Object)
end

--- Getters / Setters ---

-- Implementations / Overloaded functions
function String:setValue(sValue)
	self:_setValue(sValue)
end

function String:type()
	return 'String'
end

function String:toString()
	return self:getValue()
end
