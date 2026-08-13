USE AirlineReservationDB;
GO
--Query 1---Assignment Question
--Create a query which shows aircraft code, class code, and expected revenue for each class code, along with the total revenue of each aircraft for a given airline in a single journey. 
SELECT
    al.AirlineName,
    a.RegistrationNumber AS AircraftCode,
    f.FlightNumber,
    fc.ClassName,
    fcf.FareAmount,
    fs.AvailableSeats,
    (fcf.FareAmount * fs.AvailableSeats) AS ExpectedRevenue,
    SUM(fcf.FareAmount * fs.AvailableSeats)
        OVER(PARTITION BY a.RegistrationNumber) AS TotalAircraftRevenue
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
WHERE al.AirlineID = 1
ORDER BY
    a.RegistrationNumber,
    ExpectedRevenue DESC;
GO
---option 2
 SELECT
    a.RegistrationNumber AS AircraftCode,
    fc.ClassName,
    fcf.FareAmount,
    fs.AvailableSeats,
    (fcf.FareAmount * fs.AvailableSeats) AS ExpectedRevenue,
    SUM(fcf.FareAmount * fs.AvailableSeats)
        OVER(PARTITION BY a.RegistrationNumber) AS TotalAircraftRevenue
FROM Flight f
INNER JOIN Aircraft a
    ON f.AircraftID = a.AircraftID
INNER JOIN FlightSchedule fs
    ON f.FlightID = fs.FlightID
INNER JOIN FlightClassFare fcf
    ON fs.ScheduleID = fcf.ScheduleID
INNER JOIN FlightClass fc
    ON fcf.ClassID = fc.ClassID
WHERE a.AirlineID = 1
ORDER BY a.RegistrationNumber, fc.ClassName;
GO

--Query 2 --Assignment Question:
--Create a query which shows all passenger numbers with their corresponding descriptions of reservation status for a specific airline.
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
WHERE al.AirlineID = 1
ORDER BY
    rs.StatusName,
    p.LastName,
    p.FirstName;
GO
-- option 2
 SELECT
    p.PassengerID AS PassengerNumber,
    p.FirstName + ' ' + p.LastName AS PassengerName,
    rs.StatusName AS ReservationStatus,
    al.AirlineName
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
WHERE al.AirlineID = 1
ORDER BY p.PassengerID;
GO

--Student 1 – Query 3 --Assignment Question
--Create a query which shows the name of airline that has been most frequently travelled through by the passengers for specified source and destination in given range of dates.
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
    fs.DepartureAirportID = 1
    AND fs.ArrivalAirportID = 2
    AND fs.DepartureDateTime BETWEEN '2026-08-01' AND '2026-08-31'
GROUP BY
    al.AirlineName,
    dep.AirportCode,
    arr.AirportCode
ORDER BY
    TotalPassengers DESC;
GO
-- options 2
SELECT TOP 1
    al.AirlineName,
    COUNT(bp.PassengerID) AS TotalPassengers
FROM Airline al
INNER JOIN Flight f
    ON al.AirlineID = f.AirlineID
INNER JOIN FlightSchedule fs
    ON f.FlightID = fs.FlightID
INNER JOIN Ticket t
    ON fs.ScheduleID = t.ScheduleID
INNER JOIN BookingPassenger bp
    ON t.BookingID = bp.BookingID
WHERE fs.DepartureAirportID = 1
  AND fs.ArrivalAirportID = 2
  AND fs.DepartureDateTime BETWEEN '2026-08-01' AND '2026-08-31'
GROUP BY al.AirlineName
ORDER BY TotalPassengers DESC;
GO

--Student 1 – Query 4
--The total number of infants, children, adults & seniors travelling through specified flight in a single journey operated by a specified airline in year 2025. Result should contain both detailed breakup & summary using ROLLUP/CUBE.
SELECT
    CASE
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) < 2 THEN 'Infant'
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 2 AND 12 THEN 'Child'
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 13 AND 64 THEN 'Adult'
        ELSE 'Senior'
    END AS AgeCategory,
    COUNT(*) AS TotalPassengers,
    al.AirlineName,
    f.FlightNumber
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
    al.AirlineID = 1
    AND f.FlightNumber = 'YT101'
GROUP BY
    CASE
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) < 2 THEN 'Infant'
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 2 AND 12 THEN 'Child'
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 13 AND 64 THEN 'Adult'
        ELSE 'Senior'
    END,
    al.AirlineName,
    f.FlightNumber
ORDER BY
    AgeCategory;
GO
---options 2
SELECT
    CASE
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) < 2 THEN 'Infant'
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 2 AND 12 THEN 'Child'
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 13 AND 64 THEN 'Adult'
        ELSE 'Senior'
    END AS AgeCategory,
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
WHERE f.AirlineID = 1
  AND f.FlightID = 1
GROUP BY ROLLUP(
    CASE
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) < 2 THEN 'Infant'
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 2 AND 12 THEN 'Child'
        WHEN DATEDIFF(YEAR, p.DateOfBirth, GETDATE()) BETWEEN 13 AND 64 THEN 'Adult'
        ELSE 'Senior'
    END
);
GO

--Student 1 – Query 5 (Own Business Query), Assignment Requirement
--Develop one additional query of your own which provides information useful for the business.
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

--- Database Constraints Implementation
EXEC sp_help Flight;
GO
---Stored Procedure Creation
CREATE OR ALTER PROCEDURE sp_BookFlight
(
    @PassengerID INT,
    @ScheduleID INT,
    @JourneyTypeID INT,
    @StatusID INT,
    @ClassID INT,
    @SeatNumber VARCHAR(10),
    @TicketPrice DECIMAL(10,2),
    @TotalAmount DECIMAL(10,2)
)
AS
BEGIN
    PRINT 'Procedure Created Successfully';
END;
GO
----Stored Procedure Execution
EXEC sp_BookFlight
    @PassengerID = 1,
    @ScheduleID = 1,
    @JourneyTypeID = 1,
    @StatusID = 1,
    @ClassID = 1,
    @SeatNumber = '15C',
    @TicketPrice = 80,
    @TotalAmount = 80;
GO
----Execute the actual procedure
EXEC sp_BookFlight
    @PassengerID = 1,
    @ScheduleID = 1,
    @JourneyTypeID = 1,
    @StatusID = 1,
    @ClassID = 1,
    @SeatNumber = '15C',
    @TicketPrice = 80,
    @TotalAmount = 80;
GO

