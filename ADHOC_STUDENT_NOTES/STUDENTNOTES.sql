select n.pupil_number, sc.school, coalesce(N.MOD_DATE, n.entry_date) Note_Date, replace(replace( (select  EDP_CONV.note_long_to_varch (n.pupil_number, coalesce(N.MOD_DATE, n.entry_date))  from dual), CHR(10)), CHR(13)) from notes n
inner join students s on n.pupil_number = S.PUPIL_NUMBER
inner join schools sc on S.SCHOOL = SC.SCHOOL
where SC.BSID = 2043