USE AirlineReservationDB;
GO
--Test Case 1 — Passenger Data Verification
--Objective
--Verify that passenger records have been successfully inserted into the database.

SELECT
    PassengerID,
    FirstName + ' ' + LastName AS PassengerName,
    Nationality,
    PassportNumber
FROM Passenger
ORDER BY PassengerID;
GO
---Test Case 2 — Flight Schedule Verification
SELECT
    fs.ScheduleID,
    f.FlightNumber,
    dep.AirportCode AS DepartureAirport,
    arr.AirportCode AS ArrivalAirport,
    CAST(fs.DepartureDateTime AS DATE) AS JourneyDate,
    fs.AvailableSeats
FROM FlightSchedule fs
INNER JOIN Flight f
    ON fs.FlightID = f.FlightID
INNER JOIN Airport dep
    ON fs.DepartureAirportID = dep.AirportID
INNER JOIN Airport arr
    ON fs.ArrivalAirportID = arr.AirportID
ORDER BY fs.ScheduleID;
GO
----Test Case 3 — Booking Verification
SELECT
    b.BookingID,
    b.BookingReference,
    jt.JourneyTypeName,
    rs.StatusName AS BookingStatus,
    CAST(b.BookingDate AS DATE) AS BookingDate,
    b.TotalAmount
FROM Booking b
INNER JOIN JourneyType jt
    ON b.JourneyTypeID = jt.JourneyTypeID
INNER JOIN ReservationStatus rs
    ON b.StatusID = rs.StatusID
ORDER BY b.BookingID;
GO
---Test Case 4 — Ticket Verification
SELECT
    t.TicketID,
    t.TicketNumber,
    f.FlightNumber,
    t.SeatNumber,
    fc.ClassName,
    t.TicketPrice,
    CAST(t.IssueDate AS DATE) AS IssueDate
FROM Ticket t
INNER JOIN FlightSchedule fs
    ON t.ScheduleID = fs.ScheduleID
INNER JOIN Flight f
    ON fs.FlightID = f.FlightID
INNER JOIN FlightClass fc
    ON t.ClassID = fc.ClassID
ORDER BY t.TicketID;
GO

---Test Case 5 – Payment Verification
SELECT
    p.PaymentID,
    b.BookingReference,
    pm.MethodName AS PaymentMethod,
    p.Amount,
    p.TransactionNo,
    p.Status,
    CAST(p.PaymentDate AS DATE) AS PaymentDate
FROM Payment p
INNER JOIN Booking b
    ON p.BookingID = b.BookingID
INNER JOIN PaymentMethod pm
    ON p.PaymentMethodID = pm.PaymentMethodID
ORDER BY p.PaymentID;
GO
--Test Case 6 – Trigger Verification
SELECT
    AuditID,
    PassengerID,
    OldFirstName,
    NewFirstName,
    OldLastName,
    NewLastName,
    CAST(UpdatedDate AS DATE) AS UpdatedDate
FROM PassengerAudit
ORDER BY AuditID DESC;
GO
--Test Case 7 Stored Procedure Verification
SELECT TOP 5
    BookingID,
    BookingReference,
    BookingDate,
    TotalAmount
FROM Booking
ORDER BY BookingID DESC;
GO
--Test Case 8 Constraint Verification
EXEC sp_help Flight;
GO
--Test Case 9 User Access Control Verification
SELECT
    dp.name AS DatabaseUser,
    dp.type_desc AS UserType
FROM sys.database_principals dp
WHERE dp.type IN ('S','U')
ORDER BY dp.name;
GO
---Test Case 10 – Database View Verification
SELECT
    name
FROM sys.views
ORDER BY name;
GO
SELECT TOP 10 *
FROM vw_BookingDetails;
GO
--- Test Case 11 Database Function Verification
SELECT
    name
FROM sys.objects
WHERE type IN ('FN')
ORDER BY name;
GO
---9.11(b): Total Booking Amount Function Verification
SELECT
    BookingID,
    dbo.fn_TotalBookingAmount(BookingID) AS TotalBookingAmount
FROM Booking
ORDER BY BookingID;
GO
---Test Case  9.12 (Query Optimization Verification)
SET STATISTICS IO ON;
SET STATISTICS TIME ON;
GO

SELECT *
FROM Flight
WHERE FlightNumber = 'YT101';
GO

SET STATISTICS IO OFF;
SET STATISTICS TIME OFF;
GO
--Test Case  9.13 (Negative Trigger Validation)
INSERT INTO Ticket
(
    BookingID,
    ScheduleID,
    ClassID,
    TicketNumber,
    SeatNumber,
    TicketPrice,
    IssueDate
)
VALUES
(
    2,
    1,
    1,
    'TEST999',
    '12A',
    100,
    GETDATE()
);
GO

--Test 14 – Transaction Rollback Verification
EXEC sp_BookFlight
    @PassengerID = 999,
    @ScheduleID = 1,
    @JourneyTypeID = 1,
    @StatusID = 1,
    @ClassID = 1,
    @SeatNumber = '20A',
    @TicketPrice = 500,
    @TotalAmount = 500;
GO
SELECT TOP 5
    BookingID,
    BookingReference,
    BookingDate,
    TotalAmount
FROM Booking
ORDER BY BookingID DESC;
GO