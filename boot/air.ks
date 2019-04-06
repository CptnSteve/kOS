core:part:getmodule("kOSProcessor"):doevent("Open Terminal").
CLEARSCREEN.

// Load files for ground mission; delete boot file
deletepath("air").
copypath("0:/general_lib.ks","").
copypath("0:/air_lib.ks","").
copypath("0:/air_mission.ks","").
copypath("0:/test.ks","").


// Print the list of files local to the ship
list.
PRINT " ".

// Physics settle and/or countdown
PRINT "3".
WAIT 1.
PRINT "2".
WAIT 1.
PRINT "1".
WAIT 1.
PRINT " ".

CLEARSCREEN. 

// RUN test.ks.
RUN air_mission.ks. 