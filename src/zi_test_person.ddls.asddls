@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View Person'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_test_person as select from ztest_person
{
    key id as PersonId,
    name as Name
}
