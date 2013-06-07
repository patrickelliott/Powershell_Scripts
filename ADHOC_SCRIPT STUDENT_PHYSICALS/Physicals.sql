select pupil_number as sis_number, physical_exam_date as screen_date, 'H' as screen_type,  physical_exam_pass_fail as result  from medicals m
inner join edp_conv.e_student stu on m.pupil_number = stu.sis_number
where physical_exam_date is not null 
