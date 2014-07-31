-----------------------------------------------------------------------------------------
--
-- test.lua
--
-----------------------------------------------------------------------------------------
-- Author: Teddy Engel <engel.teddy[at]gmail.com> / @Teddy_Engel  
-- Copyright (c) 2013-2014 Teddy Engel                                                
-----------------------------------------------------------------------------------------
require ("core.tools")

function assert_has_method(oObject, sMethod)
	local sFailedMessage = ('KO - Object misses method: '..stringValue(sMethod))

	assert(oObject[sMethod] ~= nil, sFailedMessage)
end

function assert_not_has_method(oObject, sMethod)
	local sFailedMessage = ('KO - Object has method: '..stringValue(sMethod))

	print (oObject[sMethod])
	assert(oObject[sMethod] == nil, sFailedMessage)
end

function assert_nil(oValue)
	local sFailedMessage = 'KO - Got: '..stringValue(oValue)..' Expected: nil'

	assert(oValue == nil, sFailedMessage)
end

function assert_not_nil(oValue)
	local sFailedMessage = 'KO - Got: '..stringValue(oValue)..' Expected: not nil'

	assert(oValue ~= nil, sFailedMessage)
end

function assert_true(bValue)
	local sFailedMessage = 'KO: Value is '..stringValue(bValue)..', Expected: true'

	assert(bValue == true, sFailedMessage)
end

function assert_false(bValue)
	local sFailedMessage = 'KO: Value is '..stringValue(bValue)..', Expected: false'

	assert(bValue == false, sFailedMessage)
end

function assert_equals(oValue1, oValue2)
	local sValue1 = stringValue(oValue1)
	local sValue2 = stringValue(oValue2)
	local sFailedMessage = 'KO - Got: '..sValue1..' Expected: '..sValue2

	assert(sValue1 == sValue2, sFailedMessage)
end

function assert_not_equals(oValue1, oValue2)
	local sValue1 = stringValue(oValue1)
	local sValue2 = stringValue(oValue2)
	local sFailedMessage = 'KO - Got: '..sValue1..' Same as: '..sValue2

	assert(sValue1 ~= sValue2, sFailedMessage)
end

function assert_less_than(oValue1, oValue2)
	assert(type(oValue1) == 'number', 'assert_less_than expects oValue1 to be a number')
	assert(type(oValue2) == 'number', 'assert_less_than expects oValue2 to be a number')
	local sFailedMessage = 'KO - First value ('..oValue1..') must be less than second value ('..oValue2..')'

	assert(oValue1 < oValue2, sFailedMessage)
end

function assert_less_equal_than(oValue1, oValue2)
	assert(type(oValue1) == 'number', 'assert_less_than expects oValue1 to be a number')
	assert(type(oValue2) == 'number', 'assert_less_than expects oValue2 to be a number')
	local sFailedMessage = 'KO - First value ('..oValue1..') must be less or equal to second value ('..oValue2..')'

	assert(oValue1 <= oValue2, sFailedMessage)
end

function assert_higher_than(oValue1, oValue2)
	assert(type(oValue1) == 'number', 'assert_higher_than expects oValue1 to be a number')
	assert(type(oValue2) == 'number', 'assert_higher_than expects oValue2 to be a number')
	local sFailedMessage = 'KO - First value ('..oValue1..') must be higher than second value ('..oValue2..')'

	assert(oValue1 > oValue2, sFailedMessage)
end

function assert_higher_equal_than(oValue1, oValue2)
	assert(type(oValue1) == 'number', 'assert_higher_than expects oValue1 to be a number')
	assert(type(oValue2) == 'number', 'assert_higher_than expects oValue2 to be a number')
	local sFailedMessage = 'KO - First value ('..oValue1..') must be higher or equal to second value ('..oValue2..')'

	assert(oValue1 >= oValue2, sFailedMessage)
end

function assert_table_equals(oValue1, oValue2)
	assert(type(oValue1) == 'table', 'assert_table_not_equals expects oValue1 to be a table')
	assert(type(oValue2) == 'table', 'assert_table_not_equals expects oValue2 to be a table')
	local sFailedMessage = 'KO - Both tables must be equal'

	assert(oValue1 == oValue2, sFailedMessage)
end

function assert_table_not_equals(oValue1, oValue2)
	assert(type(oValue1) == 'table', 'assert_table_not_equals expects oValue1 to be a table')
	assert(type(oValue2) == 'table', 'assert_table_not_equals expects oValue2 to be a table')
	local sFailedMessage = 'KO - Both tables are equal'

	assert(oValue1 ~= oValue2, sFailedMessage)
end

function assert_function_equals(oValue1, oValue2)
	assert(type(oValue1) == 'function', 'assert_function_not_equals expects oValue1 to be a function')
	assert(type(oValue2) == 'function', 'assert_function_not_equals expects oValue1 to be a function')
	local sFailedMessage = 'KO - Both functions must be equal'

	assert(oValue1 == oValue2, sFailedMessage)
end

function assert_function_not_equals(oValue1, oValue2)
	assert(type(oValue1) == 'function', 'assert_function_not_equals expects oValue1 to be a function')
	assert(type(oValue2) == 'function', 'assert_function_not_equals expects oValue1 to be a function')
	local sFailedMessage = 'KO - Both functions are equal'

	assert(oValue1 ~= oValue2, sFailedMessage)
end
