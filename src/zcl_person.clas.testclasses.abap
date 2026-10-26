CLASS ltcl_person_test DEFINITION DEFERRED.

CLASS zcl_person DEFINITION LOCAL FRIENDS ltcl_person_test.

CLASS ltcl_person_test DEFINITION FOR TESTING
  DURATION SHORT
  RISK LEVEL HARMLESS.

  PRIVATE SECTION.
    DATA mo_cut      TYPE REF TO zcl_person.

    METHODS setup.
    methods test_setup_db_person for testing.
    methods test_setup_db_age for testing.

    methods test_read_db for testing.
    methods test_read_icds_person for testing.
    methods test_read_icds_age for testing.

    methods test_read_icds_person_nok for testing.
    methods test_read_icds_age_nok for testing.
ENDCLASS.

CLASS ltcl_person_test IMPLEMENTATION.

  METHOD setup.
    " OK
    mo_cut = NEW zcl_person( ).

  ENDMETHOD.

  method test_setup_db_person.
    " OK
    mo_cut->setup_db_person(  ).
  endmethod.

  method test_setup_db_age.
    " OK
    mo_cut->setup_db_age(  ).
  endmethod.

  method test_read_db.
    " OK
    mo_cut->read_db( ).
  endmethod.

  method test_read_icds_person.
    " OK
    mo_cut->read_icds_person(  ).
  endmethod.

  method test_read_icds_age.
    " OK
    mo_cut->read_icds_age(  ).
  endmethod.

  method test_read_icds_person_nok.
    " NOK
    mo_cut->read_icds_person_nok(  ).
  endmethod.

  method test_read_icds_age_nok.
    " NOK
    mo_cut->read_icds_age_nok(  ).
  endmethod.

ENDCLASS.
