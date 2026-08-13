/****************************************************************************************
 Project      : Airline Reservation Management System
 Module       : Advanced Database Systems
 File         : student_3_final.sql
 Description  : Student 3 - Assigned SQL Queries (FINAL, CORRECTED)
****************************************************************************************/

USE AirlineReservationDB;
GO

-- ============================================================================
-- Student 3 – Query 1, Requirement
-- Create a query which shows the journey date, number of booked seats, and
-- class name for a given passenger.
-- ============================================================================

SELECT
    p.PassengerID,
    p.FirstName + ' ' + p.LastName AS PassengerName,
    fs.DepartureDateTime AS JourneyDate,
    COUNT(t.TicketID) AS BookedSeats,
    fc.ClassName
FROM Passenger p
INNER JOIN BookingPassenger bp
    ON p.PassengerID = bp.PassengerID
INNER JOIN Booking b
    ON bp.BookingID = b.BookingID
INNER JOIN Ticket t
    ON b.BookingID = t.BookingID
INNER JOIN FlightSchedule fs
    ON t.ScheduleID = fs.ScheduleID
INNER JOIN FlightClass fc
    ON t.ClassID = fc.ClassID
WHERE p.PassengerID = 1               -- <-- change to the required passenger
GROUP BY
    p.PassengerID,
    p.FirstName,
    p.LastName,
    fs.DepartureDateTime,
    fc.ClassName
ORDER BY
    fs.DepartureDateTime;
GO

-- ============================================================================
-- Student 3 – Query 2, Requirement
-- Create a query which shows the names of meals not requested by any
-- passenger.
-- ============================================================================

SELECT
    m.MealName,
    m.MealType
FROM Meal m
WHERE NOT EXISTS
(
    SELECT 1
    FROM PassengerMeal pm
    WHERE pm.MealID = m.MealID
);
GO

-- ============================================================================
-- Student 3 – Query 3, Requirement
-- Create a query which shows the details of passengers booked through a
-- specified airline in a given date for multi-city flights.
-- ============================================================================

SELECT
    p.PassengerID,
    p.FirstName + ' ' + p.LastName AS PassengerName,
    al.AirlineName,
    jt.JourneyTypeName,
    CAST(fs.DepartureDateTime AS DATE) AS JourneyDate,
    f.FlightNumber
FROM Passenger p
INNER JOIN BookingPassenger bp
    ON p.PassengerID = bp.PassengerID
INNER JOIN Booking b
    ON bp.BookingID = b.BookingID
INNER JOIN JourneyType jt
    ON b.JourneyTypeID = jt.JourneyTypeID
INNER JOIN Ticket t
    ON b.BookingID = t.BookingID
INNER JOIN FlightSchedule fs
    ON t.ScheduleID = fs.ScheduleID
INNER JOIN Flight f
    ON fs.FlightID = f.FlightID
INNER JOIN Airline al
    ON f.AirlineID = al.AirlineID
WHERE
    al.AirlineID = 1                          -- <-- change to the required airline
    AND jt.JourneyTypeName = 'Multi-city'     -- fixed: now actually filters for multi-city trips
    AND CAST(fs.DepartureDateTime AS DATE) = '2026-08-01'  -- <-- change to the required date
ORDER BY JourneyDate;
GO

-- ============================================================================
-- Student 3 – Query 4, Requirement
-- Create a query which provides, for each airline, the total number of
-- unaccompanied passengers travelling in year 2025. The result should
-- contain detailed breakup and summary using ROLLUP or CUBE.
-- ============================================================================

SELECT
    COALESCE(al.AirlineName, 'Overall Total') AS AirlineName,
    COUNT(DISTINCT p.PassengerID) AS TotalUnaccompaniedPassengers
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
INNER JOIN PassengerSpecialService pss        -- fixed: use the actual special-service link
    ON t.TicketID = pss.TicketID
INNER JOIN SpecialService ss
    ON pss.ServiceID = ss.ServiceID
WHERE
    ss.ServiceName = 'Unaccompanied Minor'    -- fixed: correct definition of "unaccompanied"
    AND YEAR(fs.DepartureDateTime) = 2025     -- fixed: assignment requires year 2025
GROUP BY ROLLUP(al.AirlineName);
GO

-- ============================================================================
-- Student 3 – Query 5 (Own Business Query), Assignment Requirement
-- Develop one additional query of your own which provides information
-- useful for the business.
-- Business Requirement: Top revenue-generating flights.
-- ============================================================================

SELECT TOP 5
    f.FlightNumber,
    al.AirlineName,
    COUNT(t.TicketID) AS TotalTicketsSold,
    SUM(t.TicketPrice) AS TotalRevenue
FROM Flight f
INNER JOIN Airline al
    ON f.AirlineID = al.AirlineID
INNER JOIN FlightSchedule fs
    ON f.FlightID = fs.FlightID
INNER JOIN Ticket t
    ON fs.ScheduleID = t.ScheduleID
GROUP BY
    f.FlightNumber,
    al.AirlineName
ORDER BY
    TotalRevenue DESC;
GO
