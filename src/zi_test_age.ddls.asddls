@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'CDS View Age'
@Metadata.ignorePropagatedAnnotations: true
define view entity zi_test_age as select from ztest_age
{
    key id as PersonId,
    age as Age
}
