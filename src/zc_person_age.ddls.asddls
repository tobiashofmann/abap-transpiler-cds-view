@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Person with age'
@Metadata.ignorePropagatedAnnotations: true
define view entity zc_person_age 
    as select from zi_test_person as person
        inner join zi_test_age as Age on person.PersonId = Age.PersonId
{
    key person.PersonId,
    person.Name,
    Age.Age   
}
 