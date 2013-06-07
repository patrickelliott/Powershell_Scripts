/*
select s.pupil_number,
case s.legal_res_district
    WHEN 'Bethel School District 52' THEN '2088'
    WHEN 'Butte Falls School District 91' THEN '2046'
    WHEN 'Central Point School District #6' THEN '2042'
    WHEN 'Coos Bay Public Schools' THEN '1965'
    WHEN 'Eagle Point #9' THEN '2043'
    WHEN 'Eugene School District 4J' THEN '2082'
    WHEN 'Jackson County School District #9' THEN '2043'
    WHEN 'Medford School District 549C' THEN '2048'
    WHEN 'Prospect School District 59' THEN '2045'
    WHEN 'Rogue River School District #35' THEN '2044'
    WHEN 'Springfield Public Schools' THEN '2083'
    WHEN 'Three Rivers School District' THEN '2055'
ELSE ''
END as legal_res_dist_code,
CASE s.county 
    WHEN '10' THEN '15'
    WHEN '13' THEN '17'
    WHEN '4' THEN '02'
ELSE s.county
END as county
 from students s
inner join schools sc on sc.school = s.school
where sc.bsid = 2043
*/

select s.pupil_number,
s.legal_res_district_number as legal_res_dist_code,
cc.external_code as county
from students s
inner join schools sc on sc.school = s.school
inner join county_codes cc on s.county = CC.COUNTY_CODE
where sc.bsid = 2043