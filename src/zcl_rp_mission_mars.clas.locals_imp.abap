*"* use this source file for the definition and implementation of
*"* local helper classes, interface definitions and type
*"* declarations

CLASS zlcl_earth DEFINITION.

  PUBLIC SECTION.
    METHODS start_engine RETURNING VALUE(r_value) TYPE string.
    METHODS leave_orbit RETURNING VALUE(r_value) TYPE string.

ENDCLASS.

CLASS zlcl_earth IMPLEMENTATION.

  METHOD start_engine.
    r_value = 'Take off from the Earth' .
  ENDMETHOD.

  METHOD leave_orbit.
    r_value = 'Leave from Earth Orbit' .
  ENDMETHOD.

ENDCLASS.






CLASS zlcl_planet1 DEFINITION.

  PUBLIC SECTION.
    METHODS enter_orbit RETURNING VALUE(r_value) TYPE string.
    METHODS leave_orbit RETURNING VALUE(r_value) TYPE string.

ENDCLASS.

CLASS zlcl_planet1 IMPLEMENTATION.

  METHOD enter_orbit.
    r_value = 'Enter in Planet-1 Orbit' .
  ENDMETHOD.

  METHOD leave_orbit.
    r_value = 'Leave from Planet-1 Orbit' .
  ENDMETHOD.

ENDCLASS.






CLASS zlcl_mars DEFINITION.

  PUBLIC SECTION.
    METHODS enter_orbit RETURNING VALUE(r_value) TYPE string.
    METHODS explore_mars RETURNING VALUE(r_value) TYPE string.

ENDCLASS.


CLASS zlcl_mars IMPLEMENTATION.

  METHOD enter_orbit.
    r_value = 'Enter in Mars Orbit' .
  ENDMETHOD.

  METHOD explore_mars.
    r_value = 'Exploring Mars!!!!! ' .
  ENDMETHOD.

ENDCLASS.
