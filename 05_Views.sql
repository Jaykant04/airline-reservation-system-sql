/****************************************************************************************
 Project      : Airline Reservation Management System
 Module       : Advanced Database Systems
 File         : 05_Views.sql
 Description  : SQL Views
 Database     : AirlineReservationDB
 Developed By : Jaykant Sah (NP069676)
****************************************************************************************/

USE AirlineReservationDB;
GO
CREATE VIEW vw_PassengerInformation
AS
SELECT
    P.PassengerID,
    P.FirstName + ' ' + P.LastName AS FullName,
    P.Gender,
    P.DateOfBirth,
    P.PassportNumber,
    P.Nationality,
    PC.CategoryName,
    P.PhoneNumber,
    P.Email
FROM Passenger P
INNER JOIN PassengerCategory PC
ON P.CategoryID = PC.CategoryID;
GO
SELECT * FROM vw_PassengerInformation;
GO
CREATE VIEW vw_FlightSchedule
AS
SELECT
    FS.ScheduleID,
    F.FlightNumber,
    A.AirlineName,

    DA.AirportName AS DepartureAirport,
    DA.City AS DepartureCity,

    AA.AirportName AS ArrivalAirport,
    AA.City AS ArrivalCity,

    FS.DepartureDateTime,
    FS.ArrivalDateTime,
    FS.AvailableSeats

FROM FlightSchedule FS

INNER JOIN Flight F
ON FS.FlightID = F.FlightID

INNER JOIN Airline A
ON F.AirlineID = A.AirlineID

INNER JOIN Airport DA
ON FS.DepartureAirportID = DA.AirportID

INNER JOIN Airport AA
ON FS.ArrivalAirportID = AA.AirportID;
GO
SELECT * FROM vw_FlightSchedule;
GO
CREATE VIEW vw_BookingDetails
AS
SELECT

    B.BookingID,
    B.BookingReference,

    P.FirstName + ' ' + P.LastName AS Passenger,

    JT.JourneyTypeName,

    RS.StatusName,

    B.BookingDate,

    B.TotalAmount

FROM Booking B

INNER JOIN BookingPassenger BP
ON B.BookingID = BP.BookingID

INNER JOIN Passenger P
ON BP.PassengerID = P.PassengerID

INNER JOIN JourneyType JT
ON B.JourneyTypeID = JT.JourneyTypeID

INNER JOIN ReservationStatus RS
ON B.StatusID = RS.StatusID;
GO
SELECT * FROM vw_BookingDetails;
GO
-- ============================================================================
-- View: vw_TicketDetails
-- Description: Displays complete airline ticket information
-- ============================================================================

DROP VIEW IF EXISTS vw_TicketDetails;
GO

CREATE VIEW vw_TicketDetails
AS
SELECT
    T.TicketID,
    T.TicketNumber,
    B.BookingReference,

    P.FirstName + ' ' + P.LastName AS Passenger,

    A.AirlineName,
    F.FlightNumber,

    DA.AirportCode AS DepartureAirport,
    AA.AirportCode AS ArrivalAirport,

    FS.DepartureDateTime,
    FS.ArrivalDateTime,

    FC.ClassName,

    T.SeatNumber,
    T.TicketPrice,
    T.IssueDate

FROM Ticket T

INNER JOIN Booking B
    ON T.BookingID = B.BookingID

INNER JOIN BookingPassenger BP
    ON B.BookingID = BP.BookingID

INNER JOIN Passenger P
    ON BP.PassengerID = P.PassengerID

INNER JOIN FlightSchedule FS
    ON T.ScheduleID = FS.ScheduleID

INNER JOIN Flight F
    ON FS.FlightID = F.FlightID

INNER JOIN Airline A
    ON F.AirlineID = A.AirlineID

INNER JOIN Airport DA
    ON FS.DepartureAirportID = DA.AirportID

INNER JOIN Airport AA
    ON FS.ArrivalAirportID = AA.AirportID

INNER JOIN FlightClass FC
    ON T.ClassID = FC.ClassID;
GO

SELECT *
FROM vw_TicketDetails;
GO
-- ============================================================================
-- View: vw_PaymentDetails
-- Description: Displays payment information with booking details
-- ============================================================================

DROP VIEW IF EXISTS vw_PaymentDetails;
GO

CREATE VIEW vw_PaymentDetails
AS
SELECT
    PY.PaymentID,
    B.BookingReference,
    P.FirstName + ' ' + P.LastName AS Passenger,
    PM.MethodName AS PaymentMethod,
    PY.Amount,
    PY.PaymentDate,
    PY.TransactionNo,
    PY.Status
FROM Payment PY

INNER JOIN Booking B
    ON PY.BookingID = B.BookingID

INNER JOIN BookingPassenger BP
    ON B.BookingID = BP.BookingID

INNER JOIN Passenger P
    ON BP.PassengerID = P.PassengerID

INNER JOIN PaymentMethod PM
    ON PY.PaymentMethodID = PM.PaymentMethodID;
GO

SELECT * FROM vw_PaymentDetails;
GO
-- ============================================================================
-- View: vw_FlightMealDetails
-- Description: Displays meals available for each flight
-- ============================================================================

DROP VIEW IF EXISTS vw_FlightMealDetails;
GO

CREATE VIEW vw_FlightMealDetails
AS
SELECT
    FM.FlightMealID,
    F.FlightNumber,
    A.AirlineName,
    M.MealName,
    M.MealType,
    FM.Price
FROM FlightMeal FM

INNER JOIN FlightSchedule FS
    ON FM.ScheduleID = FS.ScheduleID

INNER JOIN Flight F
    ON FS.FlightID = F.FlightID

INNER JOIN Airline A
    ON F.AirlineID = A.AirlineID

INNER JOIN Meal M
    ON FM.MealID = M.MealID;
GO

SELECT * FROM vw_FlightMealDetails;
GO
CREATE OR ALTER VIEW vw_PassengerBaggage
AS
SELECT
    PB.PassengerBaggageID,
    T.TicketNumber,
    P.FirstName + ' ' + P.LastName AS Passenger,
    BT.BaggageName,
    BT.WeightKG,
    PB.Quantity,
    PB.Price
FROM PassengerBaggage PB

INNER JOIN Ticket T
    ON PB.TicketID = T.TicketID

INNER JOIN Booking B
    ON T.BookingID = B.BookingID

INNER JOIN BookingPassenger BP
    ON B.BookingID = BP.BookingID

INNER JOIN Passenger P
    ON BP.PassengerID = P.PassengerID

INNER JOIN BaggageType BT
    ON PB.BaggageTypeID = BT.BaggageTypeID;
GO

SELECT * FROM vw_PassengerBaggage;
GO
CREATE OR ALTER VIEW vw_PassengerSpecialServices
AS
SELECT
    PSS.PassengerServiceID,
    T.TicketNumber,
    P.FirstName + ' ' + P.LastName AS Passenger,
    SS.ServiceName,
    SS.Description,
    PSS.Price
FROM PassengerSpecialService PSS

INNER JOIN Ticket T
    ON PSS.TicketID = T.TicketID

INNER JOIN Booking B
    ON T.BookingID = B.BookingID

INNER JOIN BookingPassenger BP
    ON B.BookingID = BP.BookingID

INNER JOIN Passenger P
    ON BP.PassengerID = P.PassengerID

INNER JOIN SpecialService SS
    ON PSS.ServiceID = SS.ServiceID;
GO

SELECT * FROM vw_PassengerSpecialServices;
GO
CREATE OR ALTER VIEW vw_CancellationDetails
AS
SELECT
    C.CancellationID,
    T.TicketNumber,
    P.FirstName + ' ' + P.LastName AS Passenger,
    F.FlightNumber,
    C.CancellationDate,
    C.Reason,
    C.RefundAmount
FROM Cancellation C

INNER JOIN Ticket T
    ON C.TicketID = T.TicketID

INNER JOIN Booking B
    ON T.BookingID = B.BookingID

INNER JOIN BookingPassenger BP
    ON B.BookingID = BP.BookingID

INNER JOIN Passenger P
    ON BP.PassengerID = P.PassengerID

INNER JOIN FlightSchedule FS
    ON T.ScheduleID = FS.ScheduleID

INNER JOIN Flight F
    ON FS.FlightID = F.FlightID;
GO
SELECT * FROM vw_CancellationDetails;
GO
-- ============================================================================
-- View: vw_RescheduleDetails
-- Description: Displays complete ticket rescheduling details
-- ============================================================================

USE AirlineReservationDB;
GO

CREATE OR ALTER VIEW vw_RescheduleDetails
AS
SELECT
    R.RescheduleID,
    T.TicketNumber,
    P.FirstName + ' ' + P.LastName AS PassengerName,

    OFL.FlightNumber AS OldFlight,
    OLD_FS.DepartureDateTime AS OldDeparture,

    NFL.FlightNumber AS NewFlight,
    NEW_FS.DepartureDateTime AS NewDeparture,

    R.RescheduleDate,
    R.FareDifference,
    R.RescheduleFee,
    R.Reason,
    R.Status

FROM Reschedule R

INNER JOIN Ticket T
    ON R.TicketID = T.TicketID

INNER JOIN Booking B
    ON T.BookingID = B.BookingID

INNER JOIN BookingPassenger BP
    ON B.BookingID = BP.BookingID

INNER JOIN Passenger P
    ON BP.PassengerID = P.PassengerID

INNER JOIN FlightSchedule OLD_FS
    ON R.OldScheduleID = OLD_FS.ScheduleID

INNER JOIN Flight OFL
    ON OLD_FS.FlightID = OFL.FlightID

INNER JOIN FlightSchedule NEW_FS
    ON R.NewScheduleID = NEW_FS.ScheduleID

INNER JOIN Flight NFL
    ON NEW_FS.FlightID = NFL.FlightID;
GO

SELECT * FROM vw_RescheduleDetails;
GO