-- [[
 * lib65816/cpu.c Release 1p1
 * See LICENSE for more details.
 *
 * Code originally from XGS: Apple IIGS Emulator (cpu.c)
 *
 * Originally written and Copyright (C)1996 by Joshua M. Thompson
 * Copyright (C) 2006 by Samuel A. Falvo II
 *
 * Modified for greater portability and virtual hardware independence.
 ]]

#include <lib65816/config.h>
#include <lib65816/cpu.h>

CPU = {reset, abort, nmi, irq, stop, wait,
trace, update_period, cycle_count}

function CPU:setUpdatePeriod(period)
{
	self.update_period = period
}

function CPU:setTrace(mode)
{
	self.trace = mode
}

function CPU:reset()
{
	self.reset = 1
}

function CPU:abort()
{
	self.abort = 1
}

function CPU:nmi()
{
	self.nmi = 1
}

function CPU:addIRQ(m)
{
	self.irq = BU.OR(self.irq, m)
}

function CPU:clearIRQ(m)
{
	self.irq &= BU.AND(self.irq, m)
}