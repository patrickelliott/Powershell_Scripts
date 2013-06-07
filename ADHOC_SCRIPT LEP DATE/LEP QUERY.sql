select s.pupil_number, s.lep_entry_date as ENTER_DATE, s.lep_date as EXIT_DATE from students  s
inner join schools sch on s.school = sch.school
where sch.bsid = 2043
AND lep_entry_date is not null