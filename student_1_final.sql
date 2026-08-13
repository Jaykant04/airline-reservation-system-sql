/****************************************************************************************
 Project      : Airline Reservation Management System
 Module       : Advanced Database Systems
 File         : student_1_final.sql
 Description  : Student 1 - Assigned SQL Queries (FINAL, CORRECTED)
****************************************************************************************/

USE AirlineReservationDB;
GO

-- ============================================================================
-- Student 1 – Query 1, Assignment Question
-- Create a query which shows aircraft code, class code, and expected revenue
-- for each class code, along with the total revenue of each aircraft for a
-- given airline in a single journey.
-- ============================================================================

SELECT
    al.AirlineName,
    a.RegistrationNumber AS AircraftCode,
    f.FlightNumber,
    fc.ClassName,
    fcf.FareAmount,
    fs.AvailableSeats,
    (fcf.FareAmount * fs.AvailableSeats) AS ExpectedRevenue,
    SUM(fcf.FareAmount * fs.AvailableSeats)
        OVER (PARTITION BY a.RegistrationNumber) AS TotalAircraftRevenue
FROM Airline al
INNER JOIN Flight f
    ON al.AirlineID = f.AirlineID
INNER JOIN Aircraft a
    ON f.AircraftID = a.AircraftID
INNER JOIN FlightSchedule fs
    ON f.FlightID = fs.FlightID
INNER JOIN FlightClassFare fcf
    ON fs.ScheduleID = fcf.ScheduleID
INNER JOIN FlightClass fc
    ON fcf.ClassID = fc.ClassID
WHERE al.AirlineID = 1                -- <-- change to the required airline
ORDER BY
    a.RegistrationNumber,
    ExpectedRevenue DESC;
GO

-- ============================================================================
-- Student 1 – Query 2, Assignment Question
-- Create a query which shows all passenger numbers with their corresponding
-- descriptions of reservation status for a specific airline.
-- ============================================================================

SELECT
    p.PassengerID AS PassengerNumber,
    p.FirstName + ' ' + p.LastName AS PassengerName,
    rs.StatusName AS ReservationStatus,
    al.AirlineName,
    b.BookingReference,
    f.FlightNumber,
    CAST(fs.DepartureDateTime AS DATE) AS JourneyDate
FROM Passenger p
INNER JOIN BookingPassenger bp
    ON p.PassengerID = bp.PassengerID
INNER JOIN Booking b
    ON bp.BookingID = b.BookingID
INNER JOIN ReservationStatus rs
    ON b.StatusID = rs.StatusID
INNER JOIN Ticket t
    ON b.BookingID = t.BookingID
INNER JOIN FlightSchedule fs
    ON t.ScheduleID = fs.ScheduleID
INNER JOIN Flight f
    ON fs.FlightID = f.FlightID
INNER JOIN Airline al
    ON f.AirlineID = al.AirlineID
WHERE al.AirlineID = 1                -- <-- change to the required airline
ORDER BY
    rs.StatusName,
    p.LastName,
    p.FirstName;
GO

-- ============================================================================
-- Student 1 – Query 3, Assignment Question
-- Create a query which shows the name of airline that has been most
-- frequently travelled through by the passengers for specified source and
-- destination in a given range of dates.
-- ============================================================================

SELECT TOP 1
    al.AirlineName,
    dep.AirportCode AS SourceAirport,
    arr.AirportCode AS DestinationAirport,
    COUNT(bp.PassengerID) AS TotalPassengers,
    COUNT(DISTINCT f.FlightID) AS TotalFlights,
    MIN(CAST(fs.DepartureDateTime AS DATE)) AS FirstJourneyDate,
    MAX(CAST(fs.DepartureDateTime AS DATE)) AS LastJourneyDate
FROM Airline al
INNER JOIN Flight f
    ON al.AirlineID = f.AirlineID
INNER JOIN FlightSchedule fs
    ON f.FlightID = fs.FlightID
INNER JOIN Airport dep
    ON fs.DepartureAirportID = dep.AirportID
INNER JOIN Airport arr
    ON fs.ArrivalAirportID = arr.AirportID
INNER JOIN Ticket t
    ON fs.ScheduleID = t.ScheduleID
INNER JOIN BookingPassenger bp
    ON t.BookingID = bp.BookingID
WHERE
    fs.DepartureAirportID = 1                              -- <-- change to required source
    AND fs.ArrivalAirportID = 2                             -- <-- change to required destination
    AND fs.DepartureDateTime BETWEEN '2026-08-01' AND '2026-08-31'  -- <-- change to required date range
GROUP BY
    al.AirlineName,
    dep.AirportCode,
    arr.AirportCode
ORDER BY
    TotalPassengers DESC;
GO

-- ============================================================================
-- Student 1 – Query 4, Assignment Question
-- The total number of infants, children, adults & seniors travelling
-- through a specified flight in a single journey operated by a specified
-- airline in year 2025. Result should contain both detailed breakup &
-- summary using ROLLUP/CUBE.
-- ============================================================================

SELECT
    ISNULL(
        CASE
            WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) < 2  THEN 'Infant'
            WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 2 AND 12  THEN 'Child'
            WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 13 AND 64 THEN 'Adult'
            ELSE 'Senior'
        END,
        'Overall Total'
    ) AS AgeCategory,
    MAX(al.AirlineName)  AS AirlineName,
    MAX(f.FlightNumber)  AS FlightNumber,
    COUNT(*) AS TotalPassengers
FROM Passenger p
INNER JOIN BookingPassenger bp
    ON p.PassengerID = bp.PassengerID
INNER JOIN Booking b
    ON bp.BookingID = b.BookingID
INNER JOIN Ticket t
    ON b.BookingID = t.BookingID
INNER JOIN FlightSchedule fs
    ON t.ScheduleID = fs.ScheduleID
INNER JOIN Flight f
    ON fs.FlightID = f.FlightID
INNER JOIN Airline al
    ON f.AirlineID = al.AirlineID
WHERE
    al.AirlineID = 1                  -- <-- change to the required airline
    AND f.FlightNumber = 'YT101'      -- <-- change to the required flight
    AND YEAR(fs.DepartureDateTime) = 2025   -- fixed: assignment requires year 2025
GROUP BY ROLLUP(
    CASE
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) < 2  THEN 'Infant'
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 2 AND 12  THEN 'Child'
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 13 AND 64 THEN 'Adult'
        ELSE 'Senior'
    END
)
ORDER BY
    GROUPING(
        CASE
            WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) < 2  THEN 'Infant'
            WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 2 AND 12  THEN 'Child'
            WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 13 AND 64 THEN 'Adult'
            ELSE 'Senior'
        END
    ),
    AgeCategory;
GO

-- ============================================================================
-- Student 1 – Query 5 (Own Business Query), Assignment Requirement
-- Develop one additional query of your own which provides information
-- useful for the business.
-- ============================================================================

SELECT TOP 5
    p.PassengerID,
    p.FirstName + ' ' + p.LastName AS PassengerName,
    COUNT(DISTINCT b.BookingID) AS TotalBookings,
    SUM(b.TotalAmount) AS TotalSpent,
    AVG(b.TotalAmount) AS AverageBookingValue
FROM Passenger p
INNER JOIN BookingPassenger bp
    ON p.PassengerID = bp.PassengerID
INNER JOIN Booking b
    ON bp.BookingID = b.BookingID
GROUP BY
    p.PassengerID,
    p.FirstName,
    p.LastName
ORDER BY
    TotalSpent DESC;
GO

-- ============================================================================
-- NOTE: The dummy "CREATE OR ALTER PROCEDURE sp_BookFlight ... PRINT 'Procedure
-- Created Successfully'" block that was at the bottom of the original file has
-- been REMOVED here on purpose. It was silently overwriting the real,
-- working sp_BookFlight defined in 07_Stored_Procedures.sql. Do not paste it
-- back in — always use the real sp_BookFlight from 07_Stored_Procedures.sql.
-- ============================================================================
