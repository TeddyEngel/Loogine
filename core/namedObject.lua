-----------------------------------------------------------------------------------------
--
-- namedObject.lua
--
-----------------------------------------------------------------------------------------
-- Author: Teddy Engel <engel.teddy[at]gmail.com> / @Teddy_Engel  
-- Copyright (c) 2013-2014 Teddy Engel                                                
-----------------------------------------------------------------------------------------
require ("core.object") -- parent class

require ("core.string")

--- Constructor ---
local function new(self, oValue, sName, sImageFile, oSheet, nSheetFrame)
	self:_parentConstructor(Object, oValue, sImageFile, oSheet, nSheetFrame)

	-- Name
	if sName ~= nil then
		self:_setName(String(sName))
	else
		self:_setName(String(self:type()))
	end
end

NamedObject = class(new, Object)

--- Destructor ---
function NamedObject:destroy()
	local oName = self:_getName()
	if oName then
		oName:destroy()
		self:_setName(nil)
	end

	-- Calling the parent destructors
	self:_parentDestructor(Object)
end

--- Getters / Setters ---
function NamedObject:_getName()
	return self._oName
end

function NamedObject:getName()
	return self:_getName():getValue()
end

function NamedObject:_setName(oName)
	self._oName = oName
end

function NamedObject:setName(sName)
	self:_getName():setValue(sName)
end

--- TYPE RELATED ---
function NamedObject:type()
	-- To implement 
	return 'NamedObject'
end

function NamedObject:toString()
	-- To implement
	return self:getValue()
end

function NamedObject:description()
	-- To implement 
	return 'This is a simple NamedObject'
end



