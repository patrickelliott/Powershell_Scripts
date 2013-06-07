select m.pupil_number, replace(M.DENTIST_NAME, '''', '') as name, m.dentist_phone, s.medical_card_on_file as has_insurance, case  when health_card_no is null then ins_carrier_name else  ins_carrier_name||' - '||health_card_no end as insurance_company, MEDICAID  
from medicals m
inner join edp_conv.e_student stu on m.pupil_number = stu.sis_number
inner join students s on m.pupil_number = s.pupil_number
where dentist_name is not null and dentist_name != 'unknown'
or ins_carrier_name is not null