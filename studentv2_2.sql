/****************************************************************************************
 Project      : Airline Reservation Management System
 Module       : Advanced Database Systems
 File         : student_2.sql
 Description  : Student 2 - Assigned SQL Queries (Cancellation & Rescheduling Module)
****************************************************************************************/

USE AirlineReservationDB;
GO

--Student 2 – Query 1, Requirement
--Create a query which displays sorted details of flights to a given city code,
--with the least-duration flight listed first.
-- >>> NOTE: This query was missing from the original combined file — add your final version here <<<


--Student 2 – Query 2, Requirement
--Create a query which displays the types of non-vegetarian meals offered on flights.
SELECT
    m.MealName,
    m.MealType,
    f.FlightNumber,
    al.AirlineName,
    fm.Price
FROM Meal m
INNER JOIN FlightMeal fm
    ON m.MealID = fm.MealID
INNER JOIN FlightSchedule fs
    ON fm.ScheduleID = fs.ScheduleID
INNER JOIN Flight f
    ON fs.FlightID = f.FlightID
INNER JOIN Airline al
    ON f.AirlineID = al.AirlineID
WHERE m.MealType = 'Non-Vegetarian'
ORDER BY
    al.AirlineName,
    f.FlightNumber,
    m.MealName;
GO

--Student 2 – Query 3, Requirement
--Create a query which shows the names of countries to which TSI provides flight
--reservations. Ensure that duplicate country names are eliminated from the list.
SELECT
    AirportCode,
    Country
FROM Airport
ORDER BY Country, AirportCode;
GO

--Student 2 – Query 4, Assignment Requirement
--Create a query which provides, for each airline, the total number of flights
--scheduled in year 2025. Result should contain both detailed breakup & summary
--for flights for each airline along with overall summary. (Use ROLLUP or CUBE)
SELECT
    ISNULL(a.AirlineName, 'Overall Total') AS AirlineName,
    COUNT(fs.ScheduleID) AS TotalFlights
FROM Airline a
INNER JOIN Flight f
    ON a.AirlineID = f.AirlineID
INNER JOIN FlightSchedule fs
    ON f.FlightID = fs.FlightID
WHERE YEAR(fs.DepartureDateTime) = 2026 -- >>> NOTE: assignment asks for 2025, confirm/fix year <<<
GROUP BY ROLLUP(a.AirlineName)
ORDER BY AirlineName;
GO

--Student 2 – Query 5 (Own Business Query), Assignment Requirement
--Develop one additional query of your own which provides information useful
--for the business.
--Business Requirement: Top passengers based on total ticket spending.
SELECT TOP 5
    p.PassengerID,
    p.FirstName + ' ' + p.LastName AS PassengerName,
    COUNT(DISTINCT b.BookingID) AS TotalBookings,
    SUM(b.TotalAmount) AS TotalSpent
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
