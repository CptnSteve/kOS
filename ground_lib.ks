function drive_to_location {
  draw_target_arrow().
  LOCAL target_dist is 1000.
  LOCAL target_bearing is 0.

  CLEARSCREEN.

  UNTIL false {
    SET target_bearing TO ALLWAYPOINTS()[0]:GEOPOSITION:BEARING. //VANG(SHIP:FACING:VECTOR, ALLWAYPOINTS()[0]:POSITION).
    SET target_dist TO (wpvec:VEC - SHIP:POSITION:VEC):MAG.
    PRINT target_bearing AT (1,1).
    PRINT target_dist AT (1,2).

    IF ABS(target_bearing) < 5 {SET SHIP:CONTROL:WHEELTHROTTLE TO 1.} ELSE {
      SET SHIP:CONTROL:WHEELTHROTTLE TO 0.1.
      SET SHIP:CONTROL:WHEELSTEER TO MIN(1,MAX(-1,-0.003 * target_bearing)).
    }

  }
  
  PRINT "We've made it!".

}

function draw_target_arrow {
  SET wpvec TO VECDRAW().

  SET wpvec:SHOW TO TRUE.
  SET wpvec:VECUPDATER to {return ALLWAYPOINTS()[0]:POSITION.}.

}