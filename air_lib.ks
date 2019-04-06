GLOBAL target_bearing IS 0.
GLOBAL target_dist IS 99999.
GLOBAL alt_sp IS 0.
GLOBAL airspeed_sp IS 0.
GLOBAL roll_sp IS 0.
GLOBAL roll_act IS 0.
GLOBAL delta_vert_sp IS 0.
GLOBAL throttle_sp IS 1.

GLOBAL kerbin_body IS Body("Kerbin").

LOCK THROTTLE TO throttle_sp.

SET roll_pid TO PIDLOOP(0.0003,0,0.0006).
SET pitch_pid TO PIDLOOP(0.00006,0,0.0005).

function update_display
{
  PRINT "Target Bearing:  " + ROUND(target_bearing) + "  " AT (1,2).
  PRINT "Target Distance: " + ROUND(target_dist) + "  " AT (1,3).
  PRINT "Altitude SP:     " + ROUND(alt_sp) + "  " AT (1,4).

  PRINT "Vertical Speed:  " + ROUND(VERTICALSPEED,2) + "  " AT (1,6).
  PRINT "Delta_Vert SP:   " + ROUND(delta_vert_sp,2) + "  " AT (1,7).

  PRINT "Airspeed SP:     " + ROUND(airspeed_sp,2) + "  " AT (1,9).
  PRINT "AIRSPEED:        " + ROUND(AIRSPEED)  + "  " AT (1,10).
  PRINT "Throttle SP:     " + ROUND(throttle_sp,3)  + "  " AT (1,11).

  PRINT "Roll SP:         " + ROUND(roll_sp,2)  + "  " AT (1,13).
  PRINT "Roll Actual:     " + ROUND(roll_act,2)  + "  " AT (1,14).

  LOCAL i IS 0.
  FOR point IN ALLWAYPOINTS(){
    PRINT " " + i + " " + point:NAME AT (1,20+i).
    SET i TO i + 1.
  }
}

function update_controls
{
  // PROCESS VARIABLE DECLARATION: definition of actuals needed
  SET roll_act TO VANG(SHIP:UP:VECTOR,SHIP:FACING:STARVECTOR)-90.

  // SET POINT ASSIGNMENT
  // assigning variable setpoints (USE '0' POINTS TO OVERRIDE THIS)
  IF (alt_sp > 1){SET delta_vert_sp TO MAX(-2*climb_rate,MIN(climb_rate,((0.1)*(alt_sp-ALTITUDE)))).}

  // setpoint 'cleaning'
  IF (ABS(roll_sp) > 10 ) {SET delta_vert_sp TO 0.}.
  // setpoints into PID loops
  SET roll_pid:SETPOINT TO roll_sp.
  SET pitch_pid:SETPOINT TO delta_vert_sp.

  // CONTROL VARIABLE ASSIGNMENT 
  SET SHIP:CONTROL:ROLL TO SHIP:CONTROL:ROLL + roll_pid:UPDATE(TIME:SECONDS,roll_act).
  SET SHIP:CONTROL:PITCH TO SHIP:CONTROL:PITCH + pitch_pid:UPDATE(TIME:SECONDS,VERTICALSPEED).

  adjust_throttle().
  update_display().
  WAIT 0.01.
}

function adjust_throttle
{
  SET speed_diff TO airspeed_sp - AIRSPEED.
  IF airspeed_sp = 0 {
    SET throttle_sp TO 0.
  } ELSE IF speed_diff > 0.1 * airspeed_sp {
    SET throttle_sp TO 1.
  } ELSE IF speed_diff < -0.1 * airspeed_sp {
    SET throttle_sp TO 0.01.
  } ELSE {
    SET throttle_sp TO 4.75 * (airspeed_sp + speed_diff) / airspeed_sp - 4.225.
  }
}

function runway_launch
{
  PRINT "=====TAKING OFF=====" AT (1,0).
  update_display().

  // turn on brakes
  BRAKES ON.

  // full throttle
  SET airspeed_sp TO 500.
  STAGE. 

  // steer up runway
  LOCK STEERING TO HEADING(90,0).

  // wait for spool
  WAIT 5.
  
  // release brakes 
  BRAKES OFF. 
  
  // wait for speed
  UNTIL AIRSPEED > ship_land_speed{
    update_display().
  }
  UNLOCK STEERING.
  WAIT 0.01.

  // pitch up
  SET roll_sp TO 0.
  SET delta_vert_sp TO climb_rate * 2.
  
  // gain height
  UNTIL ALT:RADAR > 1000{
    update_controls().
  }
  
  // level out 
  SET delta_vert_sp TO 0.
  SET airspeed_sp TO cruise_speed.
  UNTIL ABS(VERTICALSPEED) < 5 {
    update_controls().
  }
}

function runway_land
{
  SET td_lat TO -0.26417.
  SET td_lng TO -74.424.

  PRINT "===LANDING AT KSC===" AT (1,0).
  fly_to_geopos(LATLNG(td_lat,td_lng+4),80000). // Bring in from distance
  
  PRINT "=PREPARING FINAL APPROACH=" AT (1,0).
  SET alt_sp TO 2000. // Lower alt for more stable landing
  SET airspeed_sp TO ship_land_speed * 1.5.
  fly_to_geopos(LATLNG(td_lat,td_lng+4),6000).

  SAS ON. WAIT 1. KUNIVERSE:QUICKSAVE(). SAS OFF.

  SET airspeed_sp TO ship_land_speed.

  UNTIL ALT:RADAR < 30 {
    SET target_bearing TO LATLNG(td_lat,td_lng):BEARING.
    SET dist_vect TO LATLNG(td_lat,td_lng):POSITION - GEOPOSITION:POSITION.
    SET target_dist TO dist_vect:MAG.
    
    SET alt_sp TO 70 + 200 * MAX(0,(GEOPOSITION:LNG - td_lng)).

    IF target_dist > 2000 {SET roll_sp TO MAX(MIN(1.3*target_bearing,40),-40).}
    update_controls().
  }
  // descend slowly until stopped.
    SET roll_sp TO 0.
    BRAKES ON.
    SET airspeed_sp TO 0.
  UNTIL AIRSPEED < 5 {
    PRINT "LANDING TIME!" AT (1,1).
    SET delta_vert_sp TO -1.
    update_controls().
  }
  do_science().
}

function fly_to_geopos
{
  PARAMETER geopos.
  PARAMETER dist_bubble.

  UNTIL target_dist < dist_bubble {

    SET target_bearing TO geopos:BEARING.
    SET dist_vect TO geopos:POSITION - GEOPOSITION:POSITION.
    SET target_dist TO dist_vect:MAG.

    SET roll_sp TO MAX(MIN(1.3*target_bearing,40),-40).
    update_controls().
  }
  SET target_dist TO 99999.
}

function fly_to_waypoint
{

  // find the closest waypoint in the list
  //LOCAL i IS 0.
  //LOCAL j IS 12.
  //LOCAL dist_temp IS 999999.
  //FOR point IN ALLWAYPOINTS() {
    //SET dist_vect TO point:GEOPOSITION:POSITION - GEOPOSITION:POSITION.
    //IF dist_vect:MAG < dist_temp {SET j TO i.}
    //SET i TO i + 1.
  //}

  // set target
  PRINT "=FLYING TO WAYPOINT: " + 0 + "=" AT (1,0).
  SET wp TO ALLWAYPOINTS()[0].

  SET dist_vect TO wp:GEOPOSITION:POSITION - GEOPOSITION:POSITION.
  SET target_dist TO dist_vect:MAG.

  // if too close, take a lap
  IF target_dist < 18000 {
    PRINT "=TARGET TOO CLOSE=   " AT (1,0).
    fly_to_geopos(LATLNG(wp:GEOPOSITION:LAT,wp:GEOPOSITION:LNG + 4),6000).
  }

  // fly to closest wp
  fly_to_geopos(wp:GEOPOSITION,6000).

  // do the science, then reset the science.
  SAS ON.
  do_science().
  WAIT 2.
  purge_science().
  WAIT 2. 
  SAS OFF.
}

function draw_landing_vect
{

}