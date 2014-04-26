--[[
 * lib65816/cpuevent.c Release 1p2
 * See LICENSE for more details.
 *
 * Copyright 2007 by Samuel A. Falvo II
 * Port (C) 2014 by Unit158
 ]]

#include <lib65816/cpuevent.h>
#include <stdio.h>

CPUEvent = {next, previous, counter, handler}

List = { head, null, tail }

eventList = List.new

function CPUEvent_initialize()
    eventList.head = eventList.null
    eventList.null = 0
    eventList.tail = eventList
end

function CPUEvent_elapse(cycles)
    eventList.head.counter = cycles - eventList.head.counter
    if eventList.head.counter < 0 then
    
        eventList.head.counter = 0
        CPUEvent_dispatch()
    end
end

function CPUEvent_schedule(thisEvent, when, proc)
    thisEvent.counter = when
    thisEvent.handler = proc

    p = eventList
    q = p.next

    while thisEvent.counter and q.next then
        --[[ Newly scheduled event is before 'q', so insert it in front of
         * q and compensate q's countdown accordingly.
         ]]

        if thisEvent.counter < q.counter then
            p.next = thisEvent
			thisEvent.next = q
            q.previous = thisEvent
			thisEvent.previous = p

            q.counter = thisEvent.counter - q.counter
            return
        end
        
        --[[ Otherwise, q occurs before thisEvent, so we compensate thisEvent's counter
         * as we continue to find the ideal insertion point.
         ]]

        thisEvent.counter = thisEvent.counter - q.counter
        if thisEvent.counter < 0 then thisEvent.counter = 0 end
		
		p = q
		q = q.next
    end

    p.next = thisEvent
	thisEvent.next = q
    q.previous = thisEvent
	thisEvent.previous = p
end

function CPUEvent_dispatch()
    thisEvent = eventList.head
    while thisEvent.next do
        if thisEvent.counter ~= 0 then return end

        --[[	We need to dequeue the node FIRST, because the called
         * handler may attempt to reschedule the event.
         ]]

        p = thisEvent.previous
        p.next = nextEvent
		nextEvent.previous = p
		nextEvent = thisEvent.next

        thisEvent.handler(0) 
		thisEvent = nextEvent
    end
end

