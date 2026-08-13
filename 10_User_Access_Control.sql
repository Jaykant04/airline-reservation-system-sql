/*==========================================================
 Airline Reservation Database
 User Access Control
==========================================================*/

USE master;
GO

/*==========================================================
STEP 1 : CREATE LOGINS
==========================================================*/

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name='AdminUser')
CREATE LOGIN AdminUser
WITH PASSWORD='Admin@123';

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name='ReservationOfficer')
CREATE LOGIN ReservationOfficer
WITH PASSWORD='Reserve@123';

IF NOT EXISTS (SELECT * FROM sys.server_principals WHERE name='CustomerService')
CREATE LOGIN CustomerService
WITH PASSWORD='Customer@123';

GO


/*==========================================================
STEP 2 : USE DATABASE
==========================================================*/

USE AirlineReservationDB;
GO


/*==========================================================
STEP 3 : CREATE DATABASE USERS
==========================================================*/

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name='AdminUser')
CREATE USER AdminUser FOR LOGIN AdminUser;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name='ReservationOfficer')
CREATE USER ReservationOfficer FOR LOGIN ReservationOfficer;

IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name='CustomerService')
CREATE USER CustomerService FOR LOGIN CustomerService;

GO


/*==========================================================
STEP 4 : ADMIN PERMISSION
Full Database Access
==========================================================*/

ALTER ROLE db_owner
ADD MEMBER AdminUser;

GO


/*==========================================================
STEP 5 : RESERVATION OFFICER
SELECT + INSERT + UPDATE
NO DELETE
==========================================================*/

GRANT SELECT, INSERT, UPDATE
ON Booking
TO ReservationOfficer;

GRANT SELECT, INSERT, UPDATE
ON Passenger
TO ReservationOfficer;

GRANT SELECT, INSERT, UPDATE
ON Ticket
TO ReservationOfficer;

GRANT SELECT, INSERT, UPDATE
ON Payment
TO ReservationOfficer;

GRANT SELECT
ON Flight
TO ReservationOfficer;

GRANT SELECT
ON FlightSchedule
TO ReservationOfficer;

GO


/*==========================================================
STEP 6 : CUSTOMER SERVICE
SELECT + EXECUTE STORED PROCEDURES
NO INSERT
NO UPDATE
NO DELETE
==========================================================*/

GRANT SELECT
ON Booking
TO CustomerService;

GRANT SELECT
ON Passenger
TO CustomerService;

GRANT SELECT
ON Ticket
TO CustomerService;

GRANT SELECT
ON Flight
TO CustomerService;

GRANT SELECT
ON FlightSchedule
TO CustomerService;

GRANT EXECUTE
ON SCHEMA::dbo
TO CustomerService;

GO


/*==========================================================
STEP 7 : VERIFY USERS
==========================================================*/

SELECT
name,
type_desc
FROM sys.database_principals
WHERE name IN
(
'AdminUser',
'ReservationOfficer',
'CustomerService'
);

GO

-- 10_User_Access_Control_Test.sql
/*========================================
ADMIN TEST
========================================*/

EXECUTE AS USER='AdminUser';

SELECT *
FROM Flight;

UPDATE Flight
SET Status='Scheduled'
WHERE FlightID=1;

REVERT;

GO


/*========================================
RESERVATION OFFICER TEST
========================================*/

EXECUTE AS USER='ReservationOfficer';

SELECT *
FROM Booking;

UPDATE Booking
SET TotalAmount=500
WHERE BookingID=1;

-- DELETE should fail
DELETE FROM Booking
WHERE BookingID=1;

REVERT;

GO


/*========================================
CUSTOMER SERVICE TEST
========================================*/

EXECUTE AS USER='CustomerService';

SELECT *
FROM Flight;

-- UPDATE should fail
UPDATE Flight
SET Status='Cancelled'
WHERE FlightID=1;

REVERT;

GO