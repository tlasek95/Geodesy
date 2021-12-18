# Geodesy
Projekt relacyjnej bazy danych służącej do zarządzania przedsiębiorstwem geodezyjnym. Stworzony został w języku SQL w środowisku Microsoft SQL Server 2014 Składa się ona z 11 tabel (all_jobs, job_assignments, employees, extra_time, survey_instruments, job_type, district, borough, county, customers, payments), połączonych ze sobą relacjami 1 do 1 bądź wiele - do - wielu (employees - all_jobs). Oprócz samych tabel i połączeń między nimi, zostały zaimplementowane również CONSTRAINTY, TRIGGERY, PROCEDURY SKŁADOWANE, FUNKCJE ORAZ WIDOKI.

W repozytorium znajduje się kilka plików:

tworzenie_wypelnienieBD.sql - skrypt tworzący całą bazę danych oraz wypełniający tabele przykładowymi danymi

przykladowe_zapytania.sql - skrypt zawierający przykładowe zapytania służące do wyświetlania różnych danych z bazy.

borough.txt, county.txt, customers.txt, district.txt, employees.txt, job_assignments.txt, job_type.txt, jobs.txt, payments.txt - pliki tekstowe zawierające przykładowe dane importowane do bazy danych przez BULK INSERT
