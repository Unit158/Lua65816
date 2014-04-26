repeat wait() until _G.BU ~= nil
BitInt = _G.BU

BitInt = {bits = 0, number="", dec=0}

function check(num1, num2)
	if num1.bits < num2.bits then
		error("Bit overflow!")
	end
end

function BitInt.inherit(bits, number) -- Expects binary if string.
	if type(number) == "number" then
		
		if(not bits) then
			bits = _G.BU.Log2(number)
		end
		if BU.Log2(number) > bits then
			error("Bit overflow!")
		end
		bin = _G.BU.Dec2Bin(number, bits)
		dec = _G.BU.Bin2Dec(number, bits)
		
	elseif type(bit) == "string" then bits = number:len() 
	else error("Not very descriptive error, just to make you mad.") end
		
	o = setmetatable({"isabitint", bits = bits, number = bin, dec = dec }, {__index = BitInt}) -- Don't change the first argument.
	return o
end

function BitInt.clonebitwidth(constrainedint)
	return BitInt.inherit(constrainedint.bit, 0)
end

setmetatable(BitInt, { -- KEEP number IN BINARY!
	__add = function(num, num2) check(num,num2) return BitInt.inherit(false, tonumber(_G.BU.Bin2Dec(num.number))+tonumber(_G.BU.Bin2Dec(num2.number))) end,
	__sub = function(num, num2) check(num,num2) return BitInt.inherit(false, tonumber(_G.BU.Bin2Dec(num.number))-tonumber(_G.BU.Bin2Dec(num2.number))) end,
	__mul = function(num, num2) check(num,num2) return BitInt.inherit(false, tonumber(_G.BU.Bin2Dec(num.number))*tonumber(_G.BU.Bin2Dec(num2.number))) end,
	--__mod = function(num, num2) check(num,num2) return tonumber(Bin2Dec(num.number))%tonumber(Bin2Dec(num2.number)) end, nawh man
	__equ = function(num, num2) check(num,num2) if _G.BU.Bin2Dec(num.number) == _G.BU.Bin2Dec(num2.number) then return true end end,
	--__concat = function(num, num2) check(num,num2) num.number = num2.number end, -- (Could be) used like the equals sign.})

_G.BitInt = BitInt
return BitInt