# ABAP Transpiler CDS View issue

Sample repo. Used to demonstrate an issue with ABAP Transpiler and CDS View handling.

Querying CDS Views gives an error when inline declaration (@data) is used (test cases 6 and 7). When the type is defined seperately, it works (test cases 4 and 5).

Using a C-View that queries I-Views fails at linting (test case 8).

## Content

Project contains

2 Tables: Person & Age
1 Class: ZCL_PERSON
1 ABAP Unit Class: ltcl_person_test
2 CDS I-Views: ZI_TEST_PERSON & ZI_TEST_AGE
1 CDS C-View: ZC_PERSON_AGE

## Test Cases

### Working

1) test_setup_db_person
2) test_setup_db_age
3) test_read_db
4) test_read_icds_person
5) test_read_icds_age

### Partially: Lint OK, Transpile OK, Running: NOK

6) test_read_icds_person_nok
7) test_read_icds_age_nok

### Not working: C-View

8) see branch c-view: https://github.com/tobiashofmann/abap-transpiler-cds-view/tree/c-view

Linting: OK
Transpile: NOK

Error: CDS view zc_person_age: unsupported database definition: source zi_test_person does not resolve to a TABL

Problem is that the transpiler fails to handle statement:
DATA tt_cds_p_result TYPE STANDARD TABLE OF zi_test_person WITH EMPTY KEY.

Same for SELECT * FROM zi_test_person INTO TABLE @data(results).

The types in the CDS View are not resovled and the resulting JavaScript throws an Error:

```js
async read_icds_person_nok() {
    let tt_cds_p_result = abap.types.TableFactory.construct(new abap.types.Structure({
    "personid": (() => { throw new Error("Void type: DDLS:fieldname:ZI_TEST_PERSON") })(),
    "name": (() => { throw new Error("Void type: DDLS:fieldname:ZI_TEST_PERSON") })()}, "zi_test_person", "zi_test_person", {}, {}), {"withHeader":false,"keyType":"EMPTY","primaryKey":{"name":"primary_key","type":"STANDARD","isUnique":false,"keyFields":[]},"secondary":[]}, "");
    await abap.statements.select(tt_cds_p_result, {select: "SELECT * FROM " + abap.buildDbTableName("zi_test_person") + ""});
  }
```

## Steps to reproduce

```sh
npm i
```

Linting & Transpiling:

```sh
 npm run lint
 npm run transpile
```

 Run the ABAP code:

```sh
 npm run test
```

## Outputs 

### Linter

```sh
Using config: ...abaplint.json
ABAP release: v793 (SAP_BASIS 7.93, kernel 793, on-premise 758, cloud 793, CE 2308)
ABAP language version: Normal
100% - 0.0s - Reading files - zcl_person.clas.abap
Clone: https://github.com/open-abap/open-abap-core
100% - 0.2s - Reading files - cx_a4c_cp_svc_prop_not_found.clas.abap
100% - 0.8s - Lexing and parsing(v793) - CLAS ZCL_PERSON
100% - 0.1s - Global OO types(pass 1), next pass: 177
100% - 0.0s - Global OO types(pass 2), next pass: 48
100% - 0.0s - Global OO types(pass 3), next pass: 8
100% - 0.0s - Global OO types(pass 4), next pass: 1
100% - 0.0s - Global OO types(pass 5), next pass: 0
100% - 0.0s - Run Syntax - ZCL_PERSON
100% - 0.0s - Initialize Rules - xml_consistency
100% - 0.0s - Finding Issues - CLAS ZCL_PERSON
abaplint: 0 issue(s) found, 11 file(s) analyzed
```

### Transpile

```sh
Transpiler CLI
Using config: abap_transpile.json
11 files added from source
0 files skipped in source

Building
Clone: https://github.com/open-abap/open-abap-core
        726 files added from lib
Clone: https://github.com/open-abap/open-abap-seo
        61 files added from lib
Clone: https://github.com/open-abap/open-abap-cds
        13 files added from lib
100% - 0.8s - Building, ZCL_PERSON

Output
Output files: 976 written
```

### Execution

```sh
> cds-view-abap-transpile@1.0.0 test
> node output/index.mjs

ZCL_PERSON: running ltcl_person_test->test_setup_db_person
ZCL_PERSON: running ltcl_person_test->test_setup_db_age
ZCL_PERSON: running ltcl_person_test->test_read_db
ZCL_PERSON: running ltcl_person_test->test_read_icds_person
ZCL_PERSON: running ltcl_person_test->test_read_icds_age
ZCL_PERSON: running ltcl_person_test->test_read_icds_person_nok
Error: Void type: DDLS:fieldname:ZI_TEST_PERSON
    at file:///.../output/project/zcl_person.clas.mjs:78:32
    at zcl_person.read_icds_person_nok (file:///.../output/project/zcl_person.clas.mjs:78:88)
    at #test_read_icds_person_nok (file:///.../output/project/zcl_person.clas.testclasses.mjs:61:30)
    at run (file:///.../output/index.mjs:36:51)
```

### C-CDS View

```sh
Building
Clone: https://github.com/open-abap/open-abap-core
        726 files added from lib
Clone: https://github.com/open-abap/open-abap-seo
        61 files added from lib
Clone: https://github.com/open-abap/open-abap-cds
        13 files added from lib
Error: CDS view zc_person_age: unsupported database definition: source zi_test_person does not resolve to a TABL
    at CDSDatabaseView.unsupported (...\node_modules\@abaplint\transpiler-cli\build\bundle.js:113714:15)
    at CDSDatabaseView.source (...\node_modules\@abaplint\transpiler-cli\build\bundle.js:113606:25)
```
