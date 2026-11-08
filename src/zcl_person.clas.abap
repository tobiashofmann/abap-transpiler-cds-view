CLASS zcl_person DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.
    methods constructor.

    methods setup_db_person.
    methods setup_db_age.

    methods read_db.
    methods read_icds_person.
    methods read_icds_age.
    methods read_icds_person_nok.
    methods read_icds_age_nok.

    types: begin of ty_person_age,
             personid type zperson_id,
             name     type c length 40,
             age      type int4,
           end of ty_person_age.
    types tt_person_age type standard table of ty_person_age with empty key.

    " Select all entries from C-View zc_person_age
    methods read_cds_person_age
      returning value(rt_result) type tt_person_age.

  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.

CLASS zcl_person IMPLEMENTATION.

    method constructor.
        me->setup_db_person( ).

        me->setup_db_age( ).
    endmethod.

    method setup_db_person.

        delete from ztest_person.

        "
        " Person
        "
        data lt_person type table of ztest_person.

        lt_person = value #(
            (  id = '1' name = 'Tobias' )
            (  id = '2' name = 'Joe' )
            (  id = '3' name = 'Jane' )
        ).

        insert ztest_person from table @lt_person.

    endmethod.

    method setup_db_age.

        delete from ztest_age.

        "
        " Age
        "
        data lt_age type table of ztest_age.

        lt_age = value #(
            ( id = '1' age = 48 )
            ( id = '2' age = 18 )
            ( id = '3' age = 25 )
        ).

        insert ztest_age from table @lt_Age.

    endmethod.


    Method read_db.

        " Read from DB -> OK

        select * from ztest_person into table @data(result_db_person). 

        select * from ztest_age into table @data(result_db_age). 

    endmethod.


    method read_icds_person.

        " Person

        " Transpile: OK
        " Execution: OK

        TYPES: BEGIN OF ty_person,
                    personid TYPE zperson_id,
                    name     TYPE c LENGTH 40,
                END OF ty_person.
        DATA tt_person_result TYPE STANDARD TABLE OF ty_person WITH EMPTY KEY.

        select * from zi_test_person into table @tt_person_result.

    endmethod.

    method read_icds_age.

        " Age

        " Transpile: OK
        " Execution: OK
        TYPES: BEGIN OF ty_age,
                    personid TYPE zperson_id,
                    age     TYPE int4,
                END OF ty_age.
        DATA tt_age_result TYPE STANDARD TABLE OF ty_age WITH EMPTY KEY.

        select * from zi_test_age into table @tt_age_result.
        
    endmethod.

    method read_icds_person_nok.

        " Transpile: OK 
        " Execution: NOK
        " Error: Void type: DDLS:fieldname:ZI_TEST_PERSON

        DATA tt_cds_p_result TYPE STANDARD TABLE OF zi_test_person WITH EMPTY KEY.
        SELECT * FROM zi_test_person INTO TABLE @tt_cds_p_result.

        SELECT * FROM zi_test_person INTO TABLE @data(tt_cds_p_result2).
        
    endmethod.

    method read_icds_age_nok.

        " Transpile: OK 
        " Execution: NOK
        " Error: Void type: DDLS:fieldname:ZI_TEST_AGE

        DATA tt_cds_a_result TYPE STANDARD TABLE OF zi_test_age WITH EMPTY KEY.
        SELECT * FROM zi_test_age INTO TABLE @tt_cds_a_result.

    endmethod.

    method read_cds_person_age.

        " C-View zc_person_age (joins zi_test_person and zi_test_age)
        " Type is defined separately, not inline (see read_icds_*_nok)
        select * from zc_person_age into table @rt_result.

    endmethod.

ENDCLASS.
