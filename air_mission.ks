// libraries in use
RUN ONCE general_lib.ks.
RUN ONCE air_lib.ks.

GLOBAL ship_land_speed IS 100.
GLOBAL climb_rate IS 25.

GLOBAL cruise_alt IS 6800.
GLOBAL cruise_speed IS 225.

// STAGE.

WAIT 1. 

runway_launch().

SET alt_sp TO cruise_alt.

// UNTIL ALTITUDE > 3100 AND AIRSPEED > 70 AND AIRSPEED < 140 {
  // update_controls().
// }
// STAGE.

fly_to_waypoint().
fly_to_waypoint().
fly_to_waypoint().

runway_land().
