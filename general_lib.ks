function do_science
{
  SET sci_modules_list TO list_sci_modules().
  FOR the_module IN sci_modules_list
  {
    IF (NOT the_module:HASDATA)
    {
      the_module:DEPLOY().
    }
  }
}

function purge_science
{
  SET sci_modules_list TO list_sci_modules().
  FOR the_module IN sci_modules_list
  {
    FOR the_sci_data IN the_module:DATA
    {
      IF (the_sci_data:SCIENCEVALUE < 0.1)
      {
        the_module:RESET().
      }
    }
  }
}


function list_sci_modules
{
  local sci_modules to LIST().
  local parts_list to ship:parts.

  FOR the_part IN parts_list
  {
    local module_list to the_part:MODULES.
    FOR the_module IN module_list
    {
      IF the_module:CONTAINS("ModuleScienceExperiment")
      {
        sci_modules:ADD(the_part:GETMODULE(the_module)).
        BREAK.
      }
    }
  }
  RETURN sci_modules.
}
