-- ============================================================================
-- Airline Reservation Management System
-- File: 07_Stored_Procedures.sql
-- Description: Stored Procedures
-- Developed By : Jaykant Sah (NP069676)
-- ============================================================================

USE AirlineReservationDB;
GO
-- ============================================================================
-- Stored Procedure: sp_AddPassenger
-- Description: Adds a new passenger
-- ============================================================================

USE AirlineReservationDB;
GO

-- ============================================================================
-- Stored Procedure: sp_AddPassenger
-- Description: Adds a new passenger
-- ============================================================================

CREATE OR ALTER PROCEDURE sp_AddPassenger
(
    @CategoryID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Gender VARCHAR(10),
    @DateOfBirth DATE,
    @PassportNumber VARCHAR(20),
    @Nationality VARCHAR(50),
    @PhoneNumber VARCHAR(20) = NULL,
    @Email VARCHAR(100) = NULL,
    @Address VARCHAR(255) = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        INSERT INTO Passenger
        (
            CategoryID,
            FirstName,
            LastName,
            Gender,
            DateOfBirth,
            PassportNumber,
            Nationality,
            PhoneNumber,
            Email,
            Address
        )
        VALUES
        (
            @CategoryID,
            @FirstName,
            @LastName,
            @Gender,
            @DateOfBirth,
            @PassportNumber,
            @Nationality,
            @PhoneNumber,
            @Email,
            @Address
        );

        PRINT 'Passenger added successfully.';

    END TRY

    BEGIN CATCH

        PRINT 'Error while adding passenger.';
        PRINT ERROR_MESSAGE();

    END CATCH

END;
GO
EXEC sp_AddPassenger
    @CategoryID = 1,
    @FirstName = 'John',
    @LastName = 'Smith',
    @Gender = 'Male',
    @DateOfBirth = '1995-05-20',
    @PassportNumber = 'P987654321',
    @Nationality = 'American',
    @PhoneNumber = '9800000000',
    @Email = 'john.smith@email.com',
    @Address = 'New York, USA';
GO
SELECT * FROM Passenger;
GO
-- ============================================================================
-- Stored Procedure: sp_SearchFlights
-- Description: Searches available flights based on departure airport,
--              arrival airport, and departure date.
-- ============================================================================

CREATE OR ALTER PROCEDURE sp_SearchFlights
(
    @DepartureAirportID INT,
    @ArrivalAirportID INT,
    @TravelDate DATE
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        SELECT
            FS.ScheduleID,
            F.FlightNumber,
            AL.AirlineName,

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

        INNER JOIN Airline AL
            ON F.AirlineID = AL.AirlineID

        INNER JOIN Airport DA
            ON FS.DepartureAirportID = DA.AirportID

        INNER JOIN Airport AA
            ON FS.ArrivalAirportID = AA.AirportID

        WHERE
            FS.DepartureAirportID = @DepartureAirportID
            AND FS.ArrivalAirportID = @ArrivalAirportID
            AND CAST(FS.DepartureDateTime AS DATE) = @TravelDate
            AND FS.AvailableSeats > 0

        ORDER BY FS.DepartureDateTime;

    END TRY

    BEGIN CATCH

        PRINT 'Error while searching flights.';
        PRINT ERROR_MESSAGE();

    END CATCH

END;
GO
EXEC sp_SearchFlights
    @DepartureAirportID = 1,
    @ArrivalAirportID = 2,
    @TravelDate = '2026-08-01';
GO

USE AirlineReservationDB;
GO


USE AirlineReservationDB;
GO

USE AirlineReservationDB;
GO

-- ============================================================================
-- Stored Procedure: sp_BookFlight
-- Description: Creates a new flight booking and issues a ticket.
-- ============================================================================

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
    SET NOCOUNT ON;

    DECLARE @BookingID INT;
    DECLARE @BookingReference VARCHAR(20);
    DECLARE @TicketNumber VARCHAR(30);

    BEGIN TRY

        BEGIN TRANSACTION;

        ---------------------------------------------------------
        -- Validate Passenger
        ---------------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM Passenger
            WHERE PassengerID = @PassengerID
        )
        BEGIN
            RAISERROR('Passenger does not exist.',16,1);
        END

        ---------------------------------------------------------
        -- Validate Flight Schedule
        ---------------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM FlightSchedule
            WHERE ScheduleID = @ScheduleID
        )
        BEGIN
            RAISERROR('Flight Schedule does not exist.',16,1);
        END

        ---------------------------------------------------------
        -- Check Seat Availability
        ---------------------------------------------------------
        IF
        (
            SELECT AvailableSeats
            FROM FlightSchedule
            WHERE ScheduleID = @ScheduleID
        ) <= 0
        BEGIN
            RAISERROR('No seats available.',16,1);
        END

        ---------------------------------------------------------
        -- Create Booking (Temporary Reference)
        ---------------------------------------------------------
        INSERT INTO Booking
        (
            JourneyTypeID,
            StatusID,
            BookingReference,
            BookingDate,
            TotalAmount
        )
        VALUES
        (
            @JourneyTypeID,
            @StatusID,
            'TEMP',
            GETDATE(),
            @TotalAmount
        );

        SET @BookingID = SCOPE_IDENTITY();

        ---------------------------------------------------------
        -- Generate Booking Reference
        ---------------------------------------------------------
        SET @BookingReference =
            'BK' + RIGHT('000000' + CAST(@BookingID AS VARCHAR(6)),6);

        UPDATE Booking
        SET BookingReference = @BookingReference
        WHERE BookingID = @BookingID;

        ---------------------------------------------------------
        -- Link Passenger
        ---------------------------------------------------------
        INSERT INTO BookingPassenger
        (
            BookingID,
            PassengerID
        )
        VALUES
        (
            @BookingID,
            @PassengerID
        );

        ---------------------------------------------------------
        -- Generate Ticket Number
        ---------------------------------------------------------
        SET @TicketNumber =
            'TK' + RIGHT('000000' + CAST(@BookingID AS VARCHAR(6)),6);

        ---------------------------------------------------------
        -- Issue Ticket
        ---------------------------------------------------------
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
            @BookingID,
            @ScheduleID,
            @ClassID,
            @TicketNumber,
            @SeatNumber,
            @TicketPrice,
            GETDATE()
        );

        ---------------------------------------------------------
        -- Update Available Seats
        ---------------------------------------------------------
        UPDATE FlightSchedule
        SET AvailableSeats = AvailableSeats - 1
        WHERE ScheduleID = @ScheduleID;

        COMMIT TRANSACTION;

        PRINT 'Booking created successfully.';
        PRINT 'Booking Reference: ' + @BookingReference;
        PRINT 'Ticket Number: ' + @TicketNumber;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Booking failed.';
        PRINT ERROR_MESSAGE();

    END CATCH

END;
GO
EXEC sp_BookFlight
    @PassengerID = 2,
    @ScheduleID = 1,
    @JourneyTypeID = 1,
    @StatusID = 1,
    @ClassID = 1,
    @SeatNumber = '18A',
    @TicketPrice = 500,
    @TotalAmount = 500;
GO
--
SELECT *
FROM Booking
ORDER BY BookingID DESC;
GO
--
SELECT *
FROM BookingPassenger
ORDER BY BookingID DESC;
--
SELECT *
FROM Ticket
ORDER BY TicketID DESC;
--
SELECT ScheduleID, AvailableSeats
FROM FlightSchedule;



-- ============================================================================
-- Stored Procedure: sp_MakePayment
-- Description: Processes a payment for an existing booking.
-- ============================================================================

CREATE OR ALTER PROCEDURE sp_MakePayment
(
    @BookingID INT,
    @PaymentMethodID INT,
    @Amount DECIMAL(10,2)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @TransactionNo VARCHAR(100);

    BEGIN TRY

        BEGIN TRANSACTION;

        ---------------------------------------------------------
        -- Validate Booking
        ---------------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM Booking
            WHERE BookingID = @BookingID
        )
        BEGIN
            RAISERROR('Booking does not exist.',16,1);
        END

        ---------------------------------------------------------
        -- Validate Payment Method
        ---------------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM PaymentMethod
            WHERE PaymentMethodID = @PaymentMethodID
        )
        BEGIN
            RAISERROR('Invalid payment method.',16,1);
        END

        ---------------------------------------------------------
        -- Prevent Duplicate Payment
        ---------------------------------------------------------
        IF EXISTS
        (
            SELECT 1
            FROM Payment
            WHERE BookingID = @BookingID
              AND Status = 'Completed'
        )
        BEGIN
            RAISERROR('Payment has already been completed.',16,1);
        END

        ---------------------------------------------------------
        -- Generate Transaction Number
        ---------------------------------------------------------
        SET @TransactionNo =
            'TXN'
            + CONVERT(VARCHAR(8), GETDATE(), 112)
            + RIGHT('000000' + CAST(ABS(CHECKSUM(NEWID())) % 1000000 AS VARCHAR(6)),6);

        ---------------------------------------------------------
        -- Insert Payment
        ---------------------------------------------------------
        INSERT INTO Payment
        (
            BookingID,
            PaymentMethodID,
            PaymentDate,
            Amount,
            TransactionNo,
            Status
        )
        VALUES
        (
            @BookingID,
            @PaymentMethodID,
            GETDATE(),
            @Amount,
            @TransactionNo,
            'Completed'
        );

        COMMIT TRANSACTION;

        PRINT 'Payment completed successfully.';
        PRINT 'Transaction Number: ' + @TransactionNo;

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Payment failed.';
        PRINT ERROR_MESSAGE();

    END CATCH

END;
GO

EXEC sp_MakePayment
    @BookingID = 9,
    @PaymentMethodID = 1,
    @Amount = 500.00;
GO

SELECT *
FROM Payment
ORDER BY PaymentID DESC;
GO

-- ============================================================================
-- Stored Procedure: sp_CancelBooking
-- Description: Cancels a booked ticket, restores seat availability,
--              and records the cancellation.
-- ============================================================================

CREATE OR ALTER PROCEDURE sp_CancelBooking
(
    @TicketID INT,
    @Reason VARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @BookingID INT;
    DECLARE @ScheduleID INT;
    DECLARE @RefundAmount DECIMAL(10,2);

    BEGIN TRY

        BEGIN TRANSACTION;

        ---------------------------------------------------------
        -- Validate Ticket
        ---------------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM Ticket
            WHERE TicketID = @TicketID
        )
        BEGIN
            RAISERROR('Ticket does not exist.',16,1);
        END

        ---------------------------------------------------------
        -- Prevent Duplicate Cancellation
        ---------------------------------------------------------
        IF EXISTS
        (
            SELECT 1
            FROM Cancellation
            WHERE TicketID = @TicketID
        )
        BEGIN
            RAISERROR('Ticket is already cancelled.',16,1);
        END

        ---------------------------------------------------------
        -- Get Booking & Schedule Details
        ---------------------------------------------------------
        SELECT
            @BookingID = BookingID,
            @ScheduleID = ScheduleID,
            @RefundAmount = TicketPrice
        FROM Ticket
        WHERE TicketID = @TicketID;

        ---------------------------------------------------------
        -- Insert Cancellation Record
        ---------------------------------------------------------
        INSERT INTO Cancellation
        (
            TicketID,
            CancellationDate,
            RefundAmount,
            Reason,
            Status
        )
        VALUES
        (
            @TicketID,
            GETDATE(),
            @RefundAmount,
            @Reason,
            'Approved'
        );

        ---------------------------------------------------------
        -- Update Booking Status (Cancelled = StatusID 3)
        ---------------------------------------------------------
        UPDATE Booking
        SET StatusID = 3
        WHERE BookingID = @BookingID;

        ---------------------------------------------------------
        -- Restore Available Seat
        ---------------------------------------------------------
        UPDATE FlightSchedule
        SET AvailableSeats = AvailableSeats + 1
        WHERE ScheduleID = @ScheduleID;

        COMMIT TRANSACTION;

        PRINT 'Booking cancelled successfully.';
        PRINT 'Refund Amount: ' + CAST(@RefundAmount AS VARCHAR(20));

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Cancellation failed.';
        PRINT ERROR_MESSAGE();

    END CATCH

END;
GO

EXEC sp_CancelBooking
    @TicketID = 1,
    @Reason = 'Personal reasons';
GO

SELECT *
FROM Cancellation
ORDER BY CancellationID DESC;
GO

SELECT
    BookingID,
    StatusID
FROM Booking
ORDER BY BookingID DESC;
GO

SELECT
    ScheduleID,
    AvailableSeats
FROM FlightSchedule;
GO
-- ============================================================================
-- Stored Procedure: sp_RescheduleTicket
-- Description: Reschedules an existing ticket to a new flight schedule.
-- ============================================================================

CREATE OR ALTER PROCEDURE sp_RescheduleTicket
(
    @TicketID INT,
    @NewScheduleID INT,
    @FareDifference DECIMAL(10,2)
)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @OldScheduleID INT;

    BEGIN TRY

        BEGIN TRANSACTION;

        ---------------------------------------------------------
        -- Validate Ticket
        ---------------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM Ticket
            WHERE TicketID = @TicketID
        )
        BEGIN
            RAISERROR('Ticket does not exist.',16,1);
        END

        ---------------------------------------------------------
        -- Validate New Schedule
        ---------------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM FlightSchedule
            WHERE ScheduleID = @NewScheduleID
        )
        BEGIN
            RAISERROR('New flight schedule does not exist.',16,1);
        END

        ---------------------------------------------------------
        -- Get Current Schedule
        ---------------------------------------------------------
        SELECT
            @OldScheduleID = ScheduleID
        FROM Ticket
        WHERE TicketID = @TicketID;

        ---------------------------------------------------------
        -- Prevent Same Schedule
        ---------------------------------------------------------
        IF @OldScheduleID = @NewScheduleID
        BEGIN
            RAISERROR('New schedule must be different from the current schedule.',16,1);
        END

        ---------------------------------------------------------
        -- Check Available Seats
        ---------------------------------------------------------
        IF
        (
            SELECT AvailableSeats
            FROM FlightSchedule
            WHERE ScheduleID = @NewScheduleID
        ) <= 0
        BEGIN
            RAISERROR('No seats available on the new flight.',16,1);
        END

        ---------------------------------------------------------
        -- Record Reschedule
        ---------------------------------------------------------
        INSERT INTO Reschedule
        (
            TicketID,
            OldScheduleID,
            NewScheduleID,
            RescheduleDate,
            FareDifference,
            Status
        )
        VALUES
        (
            @TicketID,
            @OldScheduleID,
            @NewScheduleID,
            GETDATE(),
            @FareDifference,
            'Approved'
        );

        ---------------------------------------------------------
        -- Update Ticket
        ---------------------------------------------------------
        UPDATE Ticket
        SET ScheduleID = @NewScheduleID
        WHERE TicketID = @TicketID;

        ---------------------------------------------------------
        -- Restore Seat to Old Flight
        ---------------------------------------------------------
        UPDATE FlightSchedule
        SET AvailableSeats = AvailableSeats + 1
        WHERE ScheduleID = @OldScheduleID;

        ---------------------------------------------------------
        -- Reduce Seat from New Flight
        ---------------------------------------------------------
        UPDATE FlightSchedule
        SET AvailableSeats = AvailableSeats - 1
        WHERE ScheduleID = @NewScheduleID;

        COMMIT TRANSACTION;

        PRINT 'Ticket rescheduled successfully.';

    END TRY

    BEGIN CATCH

        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;

        PRINT 'Reschedule failed.';
        PRINT ERROR_MESSAGE();

    END CATCH

END;
GO

SELECT
    ScheduleID,
    AvailableSeats
FROM FlightSchedule;
GO

EXEC sp_RescheduleTicket
    @TicketID = 1,
    @NewScheduleID = 2,
    @FareDifference = 20.00;
GO

SELECT *
FROM Reschedule
ORDER BY RescheduleID DESC;
GO

SELECT
    TicketID,
    ScheduleID
FROM Ticket
WHERE TicketID = 1;
GO

SELECT
    ScheduleID,
    AvailableSeats
FROM FlightSchedule
ORDER BY ScheduleID;
GO

-- ============================================================================
-- Stored Procedure: sp_GetBookingDetails
-- Description: Retrieves complete booking information.
-- ============================================================================

CREATE OR ALTER PROCEDURE sp_GetBookingDetails
(
    @BookingID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        ---------------------------------------------------------
        -- Validate Booking
        ---------------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM Booking
            WHERE BookingID = @BookingID
        )
        BEGIN
            RAISERROR('Booking does not exist.',16,1);
        END

        ---------------------------------------------------------
        -- Booking Details
        ---------------------------------------------------------
        SELECT

            B.BookingID,
            B.BookingReference,
            B.BookingDate,
            B.TotalAmount,

            RS.StatusName AS BookingStatus,

            JT.JourneyTypeName,

            P.PassengerID,
            P.FirstName + ' ' + P.LastName AS PassengerName,
            P.PassportNumber,
            P.Nationality,

            T.TicketID,
            T.TicketNumber,
            T.SeatNumber,
            T.TicketPrice,

            FC.ClassName,

            F.FlightNumber,
            A.AirlineName,

            DA.AirportName AS DepartureAirport,
            AA.AirportName AS ArrivalAirport,

            FS.DepartureDateTime,
            FS.ArrivalDateTime,

            PM.TransactionNo,
            PM.Amount AS PaidAmount,
            PM.Status AS PaymentStatus

        FROM Booking B

        INNER JOIN BookingPassenger BP
            ON B.BookingID = BP.BookingID

        INNER JOIN Passenger P
            ON BP.PassengerID = P.PassengerID

        INNER JOIN Ticket T
            ON B.BookingID = T.BookingID

        INNER JOIN FlightClass FC
            ON T.ClassID = FC.ClassID

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

        INNER JOIN JourneyType JT
            ON B.JourneyTypeID = JT.JourneyTypeID

        INNER JOIN ReservationStatus RS
            ON B.StatusID = RS.StatusID

        LEFT JOIN Payment PM
            ON B.BookingID = PM.BookingID

        WHERE B.BookingID = @BookingID;

    END TRY

    BEGIN CATCH

        PRINT 'Unable to retrieve booking details.';
        PRINT ERROR_MESSAGE();

    END CATCH

END;
GO
EXEC sp_GetBookingDetails
    @BookingID = 1;
GO
-- ============================================================================
-- Stored Procedure: sp_UpdatePassenger
-- Description: Updates passenger information with validation.
-- ============================================================================

CREATE OR ALTER PROCEDURE sp_UpdatePassenger
(
    @PassengerID INT,
    @FirstName VARCHAR(50),
    @LastName VARCHAR(50),
    @Gender VARCHAR(10),
    @DateOfBirth DATE,
    @PassportNumber VARCHAR(20),
    @Nationality VARCHAR(50),
    @PhoneNumber VARCHAR(20),
    @Email VARCHAR(100),
    @Address VARCHAR(255)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        ---------------------------------------------------------
        -- Validate Passenger
        ---------------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM Passenger
            WHERE PassengerID = @PassengerID
        )
        BEGIN
            RAISERROR('Passenger does not exist.',16,1);
            RETURN;
        END

        ---------------------------------------------------------
        -- Check Duplicate Passport
        ---------------------------------------------------------
        IF EXISTS
        (
            SELECT 1
            FROM Passenger
            WHERE PassportNumber = @PassportNumber
              AND PassengerID <> @PassengerID
        )
        BEGIN
            RAISERROR('Passport number already exists.',16,1);
            RETURN;
        END

        ---------------------------------------------------------
        -- Check Duplicate Email
        ---------------------------------------------------------
        IF @Email IS NOT NULL
        AND EXISTS
        (
            SELECT 1
            FROM Passenger
            WHERE Email = @Email
              AND PassengerID <> @PassengerID
        )
        BEGIN
            RAISERROR('Email address already exists.',16,1);
            RETURN;
        END

        ---------------------------------------------------------
        -- Update Passenger
        ---------------------------------------------------------
        UPDATE Passenger
        SET
            FirstName = @FirstName,
            LastName = @LastName,
            Gender = @Gender,
            DateOfBirth = @DateOfBirth,
            PassportNumber = @PassportNumber,
            Nationality = @Nationality,
            PhoneNumber = @PhoneNumber,
            Email = @Email,
            Address = @Address
        WHERE PassengerID = @PassengerID;

        PRINT 'Passenger information updated successfully.';

    END TRY

    BEGIN CATCH

        PRINT 'Passenger update failed.';
        PRINT ERROR_MESSAGE();

    END CATCH

END;
GO
EXEC sp_UpdatePassenger
    @PassengerID = 1,
    @FirstName = 'Jaykant',
    @LastName = 'Sah',
    @Gender = 'Male',
    @DateOfBirth = '1995-05-20',
    @PassportNumber = 'P123456789',     
    @Nationality = 'Nepali',
    @PhoneNumber = '9800000001',
    @Email = 'jaykant.sah@email.com',
    @Address = 'Kathmandu, Nepal';
GO

SELECT *
FROM Passenger
WHERE PassengerID = 1;
GO

-- ============================================================================
-- Stored Procedure: sp_GetFlightAvailability
-- Description: Retrieves flight availability by flight schedule.
-- ============================================================================

CREATE OR ALTER PROCEDURE sp_GetFlightAvailability
(
    @ScheduleID INT
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        ---------------------------------------------------------
        -- Validate Schedule
        ---------------------------------------------------------
        IF NOT EXISTS
        (
            SELECT 1
            FROM FlightSchedule
            WHERE ScheduleID = @ScheduleID
        )
        BEGIN
            RAISERROR('Flight schedule does not exist.',16,1);
            RETURN;
        END

        ---------------------------------------------------------
        -- Flight Availability
        ---------------------------------------------------------
        SELECT

            FS.ScheduleID,

            F.FlightNumber,

            A.AirlineName,

            DA.AirportName AS DepartureAirport,
            AA.AirportName AS ArrivalAirport,

            FS.DepartureDateTime,
            FS.ArrivalDateTime,

            FS.AvailableSeats,

            CASE
                WHEN FS.AvailableSeats > 0
                    THEN 'Available'
                ELSE
                    'Full'
            END AS FlightStatus

        FROM FlightSchedule FS

        INNER JOIN Flight F
            ON FS.FlightID = F.FlightID

        INNER JOIN Airline A
            ON F.AirlineID = A.AirlineID

        INNER JOIN Airport DA
            ON FS.DepartureAirportID = DA.AirportID

        INNER JOIN Airport AA
            ON FS.ArrivalAirportID = AA.AirportID

        WHERE FS.ScheduleID = @ScheduleID;

    END TRY

    BEGIN CATCH

        PRINT 'Unable to retrieve flight availability.';
        PRINT ERROR_MESSAGE();

    END CATCH

END;
GO
EXEC sp_GetFlightAvailability
    @ScheduleID = 1;
GO

-- ============================================================================
-- Stored Procedure: sp_SearchPassenger
-- Description: Searches passengers by name, passport number, or email.
-- ============================================================================

CREATE OR ALTER PROCEDURE sp_SearchPassenger
(
    @SearchText VARCHAR(100)
)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY

        SELECT

            PassengerID,
            FirstName,
            LastName,
            Gender,
            DateOfBirth,
            PassportNumber,
            Nationality,
            PhoneNumber,
            Email,
            Address

        FROM Passenger

        WHERE
            FirstName LIKE '%' + @SearchText + '%'
            OR LastName LIKE '%' + @SearchText + '%'
            OR PassportNumber LIKE '%' + @SearchText + '%'
            OR Email LIKE '%' + @SearchText + '%'

        ORDER BY
            FirstName,
            LastName;

    END TRY

    BEGIN CATCH

        PRINT 'Passenger search failed.';
        PRINT ERROR_MESSAGE();

    END CATCH

END;
GO

EXEC sp_SearchPassenger
    @SearchText = 'Jaykant';
GO
