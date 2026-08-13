/*==========================================================
 Airline Reservation Database Management System
 File Name : 11_Optimization.sql

 Purpose:
 This script implements database optimization techniques
 to improve query performance and data retrieval efficiency.

==========================================================*/

USE AirlineReservationDB;
GO

/*==========================================================
SECTION 1 : CLUSTERED INDEX INFORMATION

Note:
All Primary Keys in this database are automatically created
as Clustered Indexes by SQL Server.

Examples:
- PK_Airline
- PK_Airport
- PK_Flight
- PK_Passenger
- PK_Booking
==========================================================*/


/*==========================================================
SECTION 2 : NON-CLUSTERED INDEXES
==========================================================*/

-- Flight Number Search
IF NOT EXISTS
(
SELECT *
FROM sys.indexes
WHERE name='IX_Flight_FlightNumber'
)
CREATE NONCLUSTERED INDEX IX_Flight_FlightNumber
ON Flight(FlightNumber);
GO


-- Passenger Passport Search
IF NOT EXISTS
(
SELECT *
FROM sys.indexes
WHERE name='IX_Passenger_Passport'
)
CREATE NONCLUSTERED INDEX IX_Passenger_Passport
ON Passenger(PassportNumber);
GO


-- Passenger Email Search
IF NOT EXISTS
(
SELECT *
FROM sys.indexes
WHERE name='IX_Passenger_Email'
)
CREATE NONCLUSTERED INDEX IX_Passenger_Email
ON Passenger(Email);
GO


-- Booking Reference Search
IF NOT EXISTS
(
SELECT *
FROM sys.indexes
WHERE name='IX_Booking_Reference'
)
CREATE NONCLUSTERED INDEX IX_Booking_Reference
ON Booking(BookingReference);
GO


-- Ticket Number Search
IF NOT EXISTS
(
SELECT *
FROM sys.indexes
WHERE name='IX_Ticket_Number'
)
CREATE NONCLUSTERED INDEX IX_Ticket_Number
ON Ticket(TicketNumber);
GO


/*==========================================================
SECTION 3 : COMPOSITE INDEXES
==========================================================*/

-- Frequently searched airport route

IF NOT EXISTS
(
SELECT *
FROM sys.indexes
WHERE name='IX_FlightSchedule_Route'
)
CREATE NONCLUSTERED INDEX IX_FlightSchedule_Route
ON FlightSchedule
(
DepartureAirportID,
ArrivalAirportID
);
GO


-- Booking Search

IF NOT EXISTS
(
SELECT *
FROM sys.indexes
WHERE name='IX_Booking_Status'
)
CREATE NONCLUSTERED INDEX IX_Booking_Status
ON Booking
(
StatusID,
JourneyTypeID
);
GO


/*==========================================================
SECTION 4 : PERFORMANCE TESTING
==========================================================*/

SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO


-- Flight Search

SELECT *
FROM Flight
WHERE FlightNumber='YT101';
GO


-- Passenger Search

SELECT *
FROM Passenger
WHERE PassportNumber='NP123456';
GO


-- Booking Search

SELECT *
FROM Booking
WHERE BookingReference='BK1001';
GO


-- Ticket Search

SELECT *
FROM Ticket
WHERE TicketNumber='TK100001';
GO


SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO


/*==========================================================
SECTION 5 : VERIFY INDEXES
==========================================================*/

SELECT
name AS IndexName,
OBJECT_NAME(object_id) AS TableName,
type_desc
FROM sys.indexes
WHERE OBJECT_NAME(object_id) IN
(
'Flight',
'Passenger',
'Booking',
'Ticket',
'FlightSchedule'
)
ORDER BY TableName;
GO

--- ss 1 quary
SELECT
name AS IndexName,
OBJECT_NAME(object_id) AS TableName,
type_desc
FROM sys.indexes
WHERE OBJECT_NAME(object_id) IN
(
'Flight',
'Passenger',
'Booking',
'Ticket',
'FlightSchedule'
)
ORDER BY TableName;
GO

-- ss 2 quary
SET STATISTICS IO ON;
SET STATISTICS TIME ON;

SELECT *
FROM Flight
WHERE FlightNumber='YT101';

SELECT *
FROM Passenger
WHERE PassportNumber='NP123456';

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO