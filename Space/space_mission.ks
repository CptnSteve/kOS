LOCAL step_exec IS 0.
LOCAL flight_list IS READJSON("1:/boot/flight_step.json").

IF flight_list:LENGTH > 1{
  KUniverse:QUICKSAVE().
  WAIT 2.
}


IF flight_list:LENGTH = 1 {
  IF ALTITUDE<10000 AND BODY:NAME="Kerbin"{
    require("launch_orbit").
    launch_orbit(90).
    GEAR ON.
    SET step_exec TO 1.
  } ELSE {
    PRINT "Launch initiated outside of run condition.".
  }
}

IF flight_list:LENGTH = 2 {
  SET TARGET TO "Mun".
  require("hoh_transfer").
  hoh_transfer().
  SET TARGET TO "".
  SET step_exec TO 1.
}

IF flight_list:LENGTH = 3 {
  IF BODY:NAME="Kerbin"{
    require("deorbit").
    deorbit().
  }
}


IF step_exec = 1 {
  flight_list:ADD(flight_list:LENGTH).
}
WRITEJSON(flight_list,"1:/boot/flight_step.json").