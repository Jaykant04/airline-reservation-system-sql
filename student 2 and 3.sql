--Student 2 – Query 2  , Requirement
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

--Student 2 – Query 3,Requirement
--Create a query which shows the names of countries to which TSI provides flight reservations. Ensure that duplicate country names are eliminated from the list
SELECT
    AirportCode,
    Country
FROM Airport
ORDER BY Country, AirportCode;
GO

---Student 2 – Query 4., Assignment Requirement
--Create a query which provides, for each airline, the total number of flights scheduled in year 2025. Result should contain both detailed breakup & summary for flights for each airline along with overall summary. (Use ROLLUP or CUBE)
SELECT
    ISNULL(a.AirlineName, 'Overall Total') AS AirlineName,
    COUNT(fs.ScheduleID) AS TotalFlights
FROM Airline a
INNER JOIN Flight f
    ON a.AirlineID = f.AirlineID
INNER JOIN FlightSchedule fs
    ON f.FlightID = fs.FlightID
WHERE YEAR(fs.DepartureDateTime) = 2026
GROUP BY ROLLUP(a.AirlineName)
ORDER BY AirlineName;
GO
--Business Requirement quary 5
--Top passengers based on total ticket spending.
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

--Student 3 – Query 1, Requirement
--Create a query which shows the journey date, number of booked seats, and class name for a given passenger.
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
WHERE p.PassengerID = 1
GROUP BY
    p.PassengerID,
    p.FirstName,
    p.LastName,
    fs.DepartureDateTime,
    fc.ClassName
ORDER BY
    fs.DepartureDateTime;
GO
--Student 3 – Query 2 Requirement
--Create a query which shows the names of meals not requested by any passenger.
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
---Student 3 – Query 3, Requirement
--Create a query which shows the details of passengers booked through a specified airline in a given date for multi-city flights.
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
WHERE al.AirlineID = 1
ORDER BY JourneyDate;
GO
--Student 3 – Query 4,Requirement
--Create a query which provides, for each airline, the total number of unaccompanied passengers travelling in year 2025. The result should contain detailed breakup and summary using ROLLUP or CUBE.
SELECT
    COALESCE(al.AirlineName, 'Overall Total') AS AirlineName,
    COUNT(p.PassengerID) AS TotalUnaccompaniedPassengers
FROM Passenger p
INNER JOIN PassengerCategory pc
    ON p.CategoryID = pc.CategoryID
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
    pc.CategoryName = 'Child'
    AND YEAR(fs.DepartureDateTime) = 2026
GROUP BY ROLLUP(al.AirlineName);
GO

--Student 3 – Query 5 (Business Query) Requirement
--Develop one additional query of your own which provides information useful for the business.
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