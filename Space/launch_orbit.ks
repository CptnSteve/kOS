function launch_orbit{
  PARAMETER orbit_dir.

  require("target_twr").
  require("do_staging").

  LOCAL step_counter IS 0.

  UNTIL step_counter = 99 {
    do_staging().

    IF step_counter = 0 {
      target_twr(2).
      LOCK ang TO (3.128*10^(-8) * ALT:RADAR^2) - 0.003 * ALT:RADAR + 87.3.
      LOCK STEERING TO HEADING(orbit_dir,ang).
      STAGE.
      SET step_counter TO 1.
    }
    IF step_counter = 1 {
      IF SHIP:VELOCITY:SURFACE:MAG < 200 {WAIT 0.} ELSE {
        target_twr(1.7).
        SET step_counter TO 2.
      }
    }
    IF step_counter = 2 {
      IF ALT:RADAR < 35000 {WAIT 0.} ELSE {
        SET step_counter TO 3.
        target_twr(3).
      }
    }
    IF step_counter = 3 {
      IF APOAPSIS >= 85000 {
        LOCK THROTTLE TO 0.
        wipe_hd().
        require("circularize").
        SET step_counter TO 4.
      }
    }
    IF step_counter = 4 {
      IF ALT:RADAR > 70000 {
        circularize().
        execute_mnv().
        SET step_counter TO 99.
      }
    }
    WAIT 0.
  }
}


