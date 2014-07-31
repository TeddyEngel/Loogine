-----------------------------------------------------------------------------------------
--
-- tools.lua
--
-----------------------------------------------------------------------------------------
-- Author: Teddy Engel <engel.teddy[at]gmail.com> / @Teddy_Engel  
-- Copyright (c) 2013-2014 Teddy Engel                                                
-----------------------------------------------------------------------------------------
--- NUMBER METHODS ---
function math.clamp(value, low, high)  
    if low and value <= low then
        return low
    elseif high and value >= high then
        return high
    end
    return value
end 

--- STRING METHODS ---

-- Splits a string
function split(sText, sep)
        local sep, fields = sep or ":", {}
        local pattern = string.format("([^%s]+)", sep)
        string.gsub(sText, pattern, function(c) fields[#fields+1] = c end)
        return fields
end

-- Standard printf
function printf(format,  ...)
  print(string.format(format,  ...))
end

-- Make a simple value readable as a string
function stringValue(oValue)
	local sValue = ''

	if type(oValue) == 'table' then sValue = 'table'
	elseif type(oValue) == 'function' then sValue = 'function'
	elseif type(oValue) == 'userdata' then sValue = 'userdata'
	else
		sValue = tostring(oValue)
	end
	return sValue
end

-- Prints all values from a table
function printTable(aTable)
	if aTable and type(aTable) == 'table' then
		print ('printing table with size '..getTableSize(aTable)..':')
		print (aTable)

		for oKey, oValue in pairs(aTable) do
			print ('oKey:'..stringValue(oKey)..' oValue:'..stringValue(oValue))
		end
	end
end

function concatTable(aTable, sSeparator)
	local sFinalString = ''

	if aTable and type(aTable) == 'table' and getTableSize(aTable) > 0 then
		for oKey,oValue in pairs(aTable) do
			sFinalString = sFinalString..oValue..sSeparator
		end
		sFinalString = string.sub(sFinalString, 0, string.len(sFinalString) - 1)
	end
	return sFinalString
end

-- Creates a complete/deep copy of the data
function copyTable(object)
	local lookup_table = {}
	local function _copy(object)

	if type(object) ~= "table" then
		return object
	elseif lookup_table[object] then
		return lookup_table[object]
	end

	local new_table = {}
	lookup_table[object] = new_table
	for index, value in pairs(object) do
		new_table[_copy(index)] = _copy(value)
	end
	return setmetatable(new_table, getmetatable(object))
	end
	return _copy(object)
end

-- Function to save a table. Since game settings need to be saved from session to session, we will
-- use the Documents Directory
function insertTableIntoTable(aOrigin, aInserted)
	for oKey, oValue in pairs(aInserted) do
		if tonumber(oKey) ~= nil then
			-- Solves issue with deserializing numbers as string values
			oKey = tonumber(oKey)
		end
		if type(oValue) == 'table' then
			if aOrigin[oKey] == nil or type(aOrigin[oKey]) ~= 'table' then
				aOrigin[oKey] = {}
			end
			insertTableIntoTable(aOrigin[oKey], oValue)
		else
			aOrigin[oKey] = oValue
		end
	end
end

function clearTable(aNew, bDestroyData, ...)
	if aNew then
		local nSize = getTableSize(aNew)
		local i = 1

		for oKey,oValue in pairs(aNew) do
			if bDestroyData == true and type(oValue) == 'table' then
				if oValue.isSingleton and oValue:isSingleton() then
					oValue:destroySingleton(bDestroyData, ...)
				elseif oValue.destroy then
					oValue:destroy(bDestroyData, ...)
				end
			end
			aNew[oKey] = nil
		end
		for i = 1, nSize do
			table.remove(aNew)
		end
	end
end

function destroyTable(aNew)
	clearTable(aNew, true)
	aNew = nil
end

function getTableFirstElement(T)
	assert(type(T) == 'table', 'expects T to be a table in getTableFirstElement')
	local oFirstElement = nil

	if T.size ~= nil then
		-- If it's an advanced array
		oFirstElement = getTableFirstElement(T:getTable())
	else
		-- If it's a normal array
		for oKey, oElement in pairs(T) do 
			oFirstElement = oElement
			break
		end
	end
	return oFirstElement
end

function getTableSize(T)
	assert(type(T) == 'table', 'expects T to be a table in getTableSize')
	local nSize = 0

	if T.size ~= nil 
		and type(T.size) == 'function' then
		-- If it's an advanced array
		nSize = T:size()
	else
		-- If it's a normal array
		for _ in pairs(T) do nSize = nSize + 1 end
	end
	return nSize
end

function getTableValue(oTable, nIndex)
	local oValue = nil

	if oTable.get ~= nil then
		-- If it's an advanced array
		oValue = oTable:get(nIndex)
	else
		-- If it's a normal array
		oValue = oTable[nIndex]
	end
	return oValue
end

