-----------------------------------------------------------------------------------------
--
-- Array.lua
--
-----------------------------------------------------------------------------------------
-- Author: Teddy Engel <engel.teddy[at]gmail.com> / @Teddy_Engel  
-- Copyright (c) 2013-2014 Teddy Engel                                                
-----------------------------------------------------------------------------------------
require ("core.object") -- parent class

require ("core.tools") -- helper methods

--- Constructor ---
local function new(self)
	self:_parentConstructor(Object, nil)

	self:_setValue({})
	self:_setRandomTable({})
end

Array = class(new, Object)

--- Destructor ---
function Array:destroy(bDestroyData, ...)
	-- Specific call to destroy the data
	self:removeAll(bDestroyData, ...)

	self:_parentDestructor(Object)
end

--- Getters / Setters ---
function Array:_getRandomTable()
	return self._aRandomTable
end

function Array:_setRandomTable(aRandomTable)
	self._aRandomTable = aRandomTable
end

-- Assigns a random probability to one of the elements
function Array:setRandomPonderation(nIndex, nLow, nHigh)
	local aRandomTable = self:_getRandomTable()

	aRandomTable[nIndex] = {}
	aRandomTable[nIndex].nLow = nLow
	aRandomTable[nIndex].nHigh = nHigh
	return true
end

-- Returns a random value from the array
function Array:drawRandomValue()
	return self:getIndex(math.random(1, self:size()))
end

-- Returns a random value according to the preset random ponderations
function Array:drawRandomPresetPonderatedValue(nLow, nHigh)
	local oRandomElement = nil
	local aRandomTable = self:_getRandomTable()

	local nRandomValue = math.random(nLow, nHigh)

	for nIndex,aElement in pairs(aRandomTable) do
		if nRandomValue >= aElement.nLow
			and nRandomValue <= aElement.nHigh then
				oRandomElement = self:getIndex(nIndex)
			break
		end
	end
	return oRandomElement
end

-- Returns a random value from the object array based on the ponderated value returned from method
function Array:drawRandomPonderatedValue(sMethod)
	local aElements = self:getTable()
	local oSelectedElement = nil

	-- Create ponderations for table according to spawning chance
    local nAccumulatedChance = 0
    local nChance = nil

    -- We create the preset ponderation according to the ressource spawning chance
    for nIndex,oElement in pairs(aElements) do
    	if oElement[sMethod] == nil then
    		break
    	end
        nChance = oElement[sMethod](oElement)
        self:setRandomPonderation(nIndex, nAccumulatedChance, nAccumulatedChance + nChance)
        nAccumulatedChance = nAccumulatedChance + nChance
    end
    -- Selecting the element based on total accumulated chance
    oSelectedElement = self:drawRandomPresetPonderatedValue(1, nAccumulatedChance)
    return oSelectedElement
end

-- Implementations / Overloaded functions
function Array:setValue(oValue)
	self:_setValue(oValue)
end

function Array:type()
	return 'Array'
end

function Array:toString()
	return self:type()
end

--- Methods ---
function Array:size()
	return getTableSize(self:_getValue())
end

function Array:getTable()
	return self:_getValue()
end

function Array:get(oKey)
	local aValues = self:getTable()

	return aValues[oKey]
end

function Array:getIndex(nIndex)
	local aValues = self:getTable()
	local oSelectedValue = nil
	local i = 1

	for oKey, oValue in pairs(aValues) do
		if i == nIndex then
			oSelectedValue = oValue
			break
		end
		i = i + 1	
	end
	return oSelectedValue
end

-- Returns the index before the passed index in the collection (before 1 would be last index)
function Array:getPreviousIndex(nIndex)
	local nIndexBefore = nIndex - 1

	if nIndex == self:getFirstIndex() then
		nIndexBefore = self:getLastIndex()
	end
	return nIndexBefore
end

-- Returns the index after the passed index in the collection (after last index would be 1)
function Array:getNextIndex(nIndex)
	local nIndexAfter = nIndex + 1

	if nIndex == self:getLastIndex() then
		nIndexAfter = self:getFirstIndex()
	end
	return nIndexAfter
end

-- Returns the first index from the collection
function Array:getFirstIndex()
	return 1
end

-- Returns the last index from the collection
function Array:getLastIndex()
	return self:size()
end

-- Returns the first value from the collection
function Array:getFirstValue()
	return self:getIndex(1)
end

-- Returns the last value from the collection
function Array:getLastValue()
	return self:getIndex(self:size())
end

function Array:exists(oKey)
	return self:getTable()[oKey] ~= nil
end

-- Runs a method on all elements of the array
function Array:runMethod(oMethod, ...)
	local aValues = self:getTable()

	for oKey, oValue in pairs(aValues) do 
		assert(oValue[oMethod] ~= nil, 'Array:getMatchingMethods expects a valid oMethod, '..oMethod..' doesn\'t exist')
		oValue[oMethod](oValue, ...)
	end
end

-- Returns a table with all this array keys in it
function Array:getKeys()
	local aValues = self:getTable()
	local aKeys = {}
	local i = 1

	for oKey, oValue in pairs(aValues) do 
		aKeys[i] = oKey
		i = i + 1
	end
	return aKeys
end

-- Gets an array() of elements for which the result of the method name given is equal to match value
function Array:getMatchingMethods(sMethod, oMatchValue, ...)
	local aValues = self:getTable()
	local oaMatching = Array()
	local i = 1

	for oKey, oValue in pairs(aValues) do 
		assert(oValue[sMethod] ~= nil, 'Array:getMatchingMethods expects a valid sMethod')
		if oValue[sMethod](oValue, ...) == oMatchValue then
			oaMatching:insertAt(i, oValue)
			i = i + 1
		end
	end
	return oaMatching
end

-- Gets a lua table of elements matching the method
function Array:getMatchingMethodsAsTable(sMethod, oMatchValue, ...)
	local oaMatchingElements = self:getMatchingMethods(sMethod, oMatchValue, ...)
	local aMatchingElements = table.copy(oaMatchingElements:getTable())

	oaMatchingElements:destroy(false)
	oaMatchingElements = nil
	return aMatchingElements
end

-- Gets the first element matching (even if multiple ones are matching)
function Array:getMatchingElementByMethod(sMethod, oMatchValue)
	local oaMatchingElements = self:getMatchingMethods(sMethod, oMatchValue)
	local aElements = oaMatchingElements:getTable()
	local oElement = nil

	if aElements then
		oElement = getTableFirstElement(aElements)
	end
	oaMatchingElements:destroy(false)
	oaMatchingElements = nil
	return oElement
end

function Array:getMatchingElementById(nId)
	return self:getMatchingElementByMethod('getId', nId)
end

function Array:getMatchingElementByName(sName)
	return self:getMatchingElementByMethod('getName', sName)
end

function Array:getMatchingElementByType(sType)
	return self:getMatchingElementByMethod('type', sType)
end

function Array:getValuesByType()
	local aValues = self:getTable()
	local aKeys = {}
	local i = 1

	for oKey, oValue in pairs(aValues) do 
		if type(oValue) == 'table' and oValue.type ~= nil then
			aKeys[i] = oValue:type()
			i = i + 1
		end
	end
	return aKeys
end

function Array:getValuesByName()
	local aValues = self:getTable()
	local aKeys = {}
	local i = 1

	for oKey, oValue in pairs(aValues) do 
		if type(oValue) == 'table' and oValue.getName ~= nil then
			aKeys[i] = oValue:getName()
			i = i + 1
		end
	end
	return aKeys
end

function Array:getValuesByMember(oMember)
	local aValues = self:getTable()
	local aKeys = {}
	local i = 1

	for oKey, oValue in pairs(aValues) do 
		aKeys[i] = oValue[oMember]
		i = i + 1
	end
	return aKeys
end

function Array:find(oSoughtValue)
	local nSlot = nil
	local aValues = self:getTable()

	for oKey,oValue in pairs(aValues) do
		if oSoughtValue == oValue then
			nSlot = oKey
			break
		end
	end
	return nSlot
end

function Array:insertAt(nIndex, oValue)
	local aArray = self:getTable()

	aArray[nIndex] = oValue
end

function Array:_getFirstFreeIndex()
	local nSize = self:size()
	local aValues = self:getTable()
	local nIndex = nil

	for i=1, nSize + 1 do
		if aValues[i] == nil then
			nIndex = i
			break
		end
		i = i + 1
	end
	return nIndex
end

-- Inserts in the first free slot in the array
function Array:insert(oValue)
	if oValue then
		self:insertAt(self:_getFirstFreeIndex(), oValue)
	end
end

-- Inserts all values from the given table into this table
function Array:insertAll(oValues)
	assert(oValues ~= nil, 'expects a valid oValues')
	assert(type(oValues) == 'table', 'expects oValues to be a table')
	local aValues = oValues

	-- To handle if the array passed is an Array()
	if oValues.type and oValues:type() == 'Array' then
		aValues = oValues:getTable()
	end
	-- Inserting all values from the internal array to this array
	for oKey,oValue in pairs(aValues) do 
		self:insert(oValue)
	end
end

-- Removes the given value from the table, if found
function Array:remove(oRemovedValue)
	local bFound = false
	local aValues = self:getTable()

	for oKey,oValue in pairs(aValues) do 
		if oRemovedValue == oValue then
			aValues[oKey] = nil
			bFound = true
			break
		end
	end
	return bFound
end

-- Removes the given value from the table, if found
function Array:removeKey(oRemovedKey)
	local bFound = false
	local aValues = self:getTable()

	for oKey,oValue in pairs(aValues) do 
		if oRemovedKey == oKey then
			aValues[oKey] = nil
			bFound = true
			break
		end
	end
	return bFound
end

-- Removes the value at a specific index
function Array:removeAt(nIndex)
	local aValues = self:getTable()
	table.remove(aValues, nIndex)
end

-- Removes all values from the array
function Array:removeAll(bDestroyData, ...)
	clearTable(self:getTable(), bDestroyData, ...)
	clearTable(self:_getRandomTable(), bDestroyData, ...)
end
