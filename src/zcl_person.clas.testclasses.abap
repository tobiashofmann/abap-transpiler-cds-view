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

    methods test_read_cds_person_age for testing.
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

  method test_read_cds_person_age.
    " C-View zc_person_age returns all entries

    delete from ztest_person.
    delete from ztest_age.

    data lt_person type table of ztest_person.
    data lt_age    type table of ztest_age.

    lt_person = value #(
      ( id = '1' name = 'Dummy A' )
      ( id = '2' name = 'Dummy B' )
      ( id = '3' name = 'Dummy C' )
    ).
    insert ztest_person from table @lt_person.

    lt_age = value #(
      ( id = '1' age = 10 )
      ( id = '2' age = 20 )
      ( id = '3' age = 30 )
    ).
    insert ztest_age from table @lt_age.

    data(lt_result) = mo_cut->read_cds_person_age( ).

    cl_abap_unit_assert=>assert_equals(
      act = lines( lt_result )
      exp = 3 ).

    read table lt_result with key personid = '2' into data(ls_row).
    cl_abap_unit_assert=>assert_subrc( ).
    cl_abap_unit_assert=>assert_equals(
      act = ls_row-age
      exp = 20 ).
  endmethod.

ENDCLASS.
