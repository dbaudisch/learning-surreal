DEFINE TABLE OVERWRITE viewed
    TYPE RELATION
    IN user OUT post|series|topic ENFORCED
    SCHEMAFULL
;

DEFINE FIELD OVERWRITE date
    ON TABLE viewed
    TYPE datetime
    VALUE time::now()
    READONLY
;

-- TODO: Make it keep only last 10 entries for each unique user->thing