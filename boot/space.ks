SET ship_core TO CORE:PART:GETMODULE("kOSProcessor").
ship_core:doevent("Open Terminal"). 
CLEARSCREEN. 
SWITCH TO 1.
PRINT "3". WAIT 1.PRINT "2". WAIT 1.PRINT "1". WAIT 1.

FUNCTION require{
  PARAMETER file_name.

  IF NOT ship_core:VOLUME:FILES:HASVALUE(file_name){
    IF EXISTS("0:/"+file_name+".ks"){
      COPYPATH("0:/"+file_name+".ks","").
    } ELSE {
        COPYPATH("0:/Space/"+file_name+".ks","").
    }
  }
  PRINT file_name + " loaded. Drive Usage: " + (VOLUME(1):CAPACITY - VOLUME(1):FREESPACE).
  RUNONCEPATH(file_name).
}

FUNCTION wipe_hd {
  SWITCH TO 1.
  LIST FILES IN file_list.
  FOR my_file IN file_list {
    IF my_file <> "space.ks" AND my_file <> "boot" AND my_file <> "flight_plan.ks" {
      PRINT "DELETING: " + my_file.
      DELETEPATH(my_file).
    }
  }
}

IF NOT EXISTS("1:/flight_plan.ks"){
  COPYPATH("0:/Space/space_mission.ks","1:/flight_plan.ks").
  LOCAL flight_list IS LIST(). 
  flight_list:ADD(0).
  WRITEJSON(flight_list,"1:/boot/flight_step.json").
}

IF EXISTS("0:/OVERRIDE.ks"){
  COPYPATH("0:/OVERRIDE.ks","").
  RUN OVERRIDE.
} ELSE {
  RUN flight_plan.
}

wipe_hd().