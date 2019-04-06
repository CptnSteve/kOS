function launch_suborbital{
  PARAMETER height_sp.

  require("do_staging").
  require("target_twr").

  LOCAL step_counter IS 0.
  
  target_twr(2.5).
  LOCK STEERING TO HEADING(90,83).
  
  STAGE.

  UNTIL step_counter = 99 {
    do_staging().
    IF step_counter = 0 {
      IF APOAPSIS > height_sp{
        LOCK THROTTLE TO 0.
        WAIT 1.
        SET step_counter TO step_counter + 1.
      }
    }
    IF step_counter = 1 {
      LOCK STEERING TO RETROGRADE. 
      WAIT 1.
      SET step_counter TO 99.
    }
    
  }

}
