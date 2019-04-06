
function do_staging {
  LIST PARTS IN my_parts.
  FOR part IN my_parts{
    IF part:RESOURCES:LENGTH <> 0 {
      FOR res IN part:RESOURCES{
        IF res:NAME = "LIQUIDFUEL" OR res:NAME = "SOLIDFUEL" OR res:NAME = "OXIDIZER"{
          IF res:AMOUNT < 0.1 {
            STAGE. RETURN.
          }
        }
      }
    }
  }
}
