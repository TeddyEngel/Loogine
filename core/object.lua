-----------------------------------------------------------------------------------------
--
-- object.lua
--
-----------------------------------------------------------------------------------------
-- Author: Teddy Engel <engel.teddy[at]gmail.com> / @Teddy_Engel  
-- Copyright (c) 2013-2014 Teddy Engel                                                
-----------------------------------------------------------------------------------------
require ("luoop.luoop")

local nNextId = 1

--- Constructor ---
local function new(self, oValue, sImageFile, oSheet, nSheetFrame)
	-- Sets the original value
	self:_setValue(oValue)

	-- Sets the previous value
	self:_setPreviousValue(nil)

	-- Assigning an id
	self:_setId(nNextId)
	nNextId = nNextId + 1

	-- Image file (to display in case of a render call)
	self:_setImageFile(sImageFile)

	self:_setSheet(oSheet)
	self:_setSheetFrame(nSheetFrame)
end

Object = class(new)

--- Destructor ---
function Object:destroy()
	self:_setSheetFrame(nil)
	self:_setSheet(nil)
	self:_setImageFile(nil)

	self:_setId(nil)

	local oPreviousValue = self:_getPreviousValue()
	if oPreviousValue and type(oPreviousValue) == 'table' and oPreviousValue.destroy and oPreviousValue ~= self then
		oPreviousValue:destroy()
	end
	self:_setPreviousValue(nil)

	local oValue = self:_getValue()
	if oValue and type(oValue) == 'table' and oValue.destroy and oValue ~= self then
		oValue:destroy()
	end
	self:_setValue(nil)
end

--- Getters / Setters ---
function Object:_getValue()
	return self._oValue
end

function Object:getValue()
	return self:_getValue()
end

function Object:_setValue(oValue)
	self._oValue = oValue
end

function Object:setValue(oValue)
	local oPreviousValue = self:_getPreviousValue()
	if oPreviousValue and type(oPreviousValue) == 'table' and oPreviousValue.destroy and oPreviousValue ~= self then
		oPreviousValue:destroy()
	end
	self:_setPreviousValue(self:_getValue())
	self:_setValue(oValue)
	return true
end

function Object:_getPreviousValue()
	return self._oPreviousValue
end

function Object:getPreviousValue()
	return self:_getPreviousValue()
end

function Object:_setPreviousValue(oPreviousValue)
	self._oPreviousValue = oPreviousValue
end

function Object:setPreviousValue(oPreviousValue)
	self:_setPreviousValue(oPreviousValue)
end

function Object:_getId()
	return self._nId
end

function Object:getId()
	return self:_getId()
end

function Object:_setId(nId)
	self._nId = nId
end

function Object:setId(nId)
	self:_setId(nId)
end

function Object:_getImageFile()
	return self._sImageFile
end

function Object:getImageFile()
	return self:_getImageFile()
end

function Object:_setImageFile(sImageFile)
	self._sImageFile = sImageFile
end

function Object:setImageFile(sImageFile)
	self:_setImageFile(sImageFile)
end

function Object:_getSheet()
	return self._oSheet
end

function Object:_setSheet(oSheet)
	self._oSheet = oSheet
end

function Object:_getSheetFrame()
	return self._nSheetFrame
end

function Object:_setSheetFrame(nSheetFrame)
	self._nSheetFrame = nSheetFrame
end

--- TYPE RELATED ---
function Object:type()
	-- To implement 
	return 'Object'
end

function Object:toString()
	-- To implement
	return self:getValue()
end

-- Text displayed when an image cannot be displayed for some reason
function Object:toAlt()
	return self:toString()
end

function Object:toImage()
	local oSheet = self:_getSheet()
	if oSheet then 
		return oSheet, self:_getSheetFrame()
	else
		return self:_getImageFile()
	end
end

function Object:description()
	-- To implement 
	return 'This is a simple object'
end

-- Returns a new instance of the same class as this object (without copying all content)
function Object:clone(...)
	-- To implement for specifics
 	return self:new(...)
end

