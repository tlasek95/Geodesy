-- wyswietlenie numeru pracy, położenia, rodzaju pracy oraz ceny

SELECT a.TZnumber AS numerTZ, d.name AS obreb, b.name AS gmina, c.name AS powiat, j.jobType AS rodzajPracy,
	CASE 
		WHEN a.jobTypeID = 1 THEN a.area * (SELECT price FROM job_type WHERE ID = 1)
		WHEN a.jobTypeID = 2 OR a.jobTypeID = 4 THEN (SELECT price FROM job_type WHERE ID = 2)
		WHEN a.jobTypeID = 3 OR a.jobTypeID = 5 THEN a.length/100 * (SELECT price FROM job_type WHERE ID = 3)
		WHEN a.jobTypeID = 6 THEN a.noOfAxles *	(SELECT price FROM job_type WHERE ID = 6)	
		WHEN a.jobTypeID = 7 THEN (SELECT price FROM job_type WHERE ID = 7)
		ELSE (SELECT price FROM job_type WHERE ID = 8) 
	END AS cena				  
FROM all_jobs AS a
JOIN district AS d ON (d.ID = a.districtID)
JOIN borough AS b ON (b.ID = d.boroughID)
JOIN county AS c ON (c.ID = b.countyID)
JOIN job_type AS j ON (j.ID = a.jobTypeID)

-- wyswietlenie prac i przydzielonych do nich pracownikow oraz instrumentow

SELECT a.TZnumber, t.jobType, e.lastName, s.name FROM job_assignments AS ja
JOIN all_jobs AS a ON (a.ID = ja.jobID)
JOIN employees AS e ON (e.ID = ja.employeeID)
JOIN survey_instruments AS s ON (s.ID = ja.instrumentID)
JOIN job_type AS t ON (t.ID = a.jobTypeID)

