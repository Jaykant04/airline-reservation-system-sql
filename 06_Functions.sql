/****************************************************************************************
 Project      : Airline Reservation Management System
 Module       : Advanced Database Systems
 File         : 06_Functions.sql
 Description  : Function.sql
 Database     : AirlineReservationDB
 Developed By : Jaykant Sah (NP069676)
****************************************************************************************/

USE AirlineReservationDB;
GO
-- ============================================
-- Function 1: Get Total Booking Amount
-- ============================================

CREATE FUNCTION fn_TotalBookingAmount
(
    @BookingID INT
)
RETURNS DECIMAL(10,2)
AS
BEGIN
    DECLARE @Total DECIMAL(10,2);

    SELECT @Total = TotalAmount
    FROM Booking
    WHERE BookingID = @BookingID;

    RETURN ISNULL(@Total,0);
END;
GO
-- Test
SELECT dbo.fn_TotalBookingAmount(1) AS TotalAmount;
GO

-- ============================================
-- Function 2: Get Available Seats
-- ============================================

CREATE FUNCTION fn_AvailableSeats
(
    @ScheduleID INT
)
RETURNS INT
AS
BEGIN
    DECLARE @Seats INT;

    SELECT @Seats = AvailableSeats
    FROM FlightSchedule
    WHERE ScheduleID = @ScheduleID;

    RETURN ISNULL(@Seats,0);
END;
GO

-- Test
SELECT dbo.fn_AvailableSeats(1) AS AvailableSeats;
GO
-- ============================================
-- Function 3: Get Passenger Full Name
-- ============================================

CREATE FUNCTION fn_PassengerFullName
(
    @PassengerID INT
)
RETURNS VARCHAR(150)
AS
BEGIN
    DECLARE @FullName VARCHAR(150);

    SELECT @FullName = FirstName + ' ' + LastName
    FROM Passenger
    WHERE PassengerID = @PassengerID;

    RETURN ISNULL(@FullName,'Passenger Not Found');
END;
GO
-- Test
SELECT dbo.fn_PassengerFullName(1) AS PassengerName;
GO