-- ============================================================================
-- Airline Reservation Management System
-- File: 08_Triggers.sql
--  Description: Prevents duplicate seat assignment for the same flight schedule.
-- Developed By : Jaykant Sah (NP069676)
-- ============================================================================

USE AirlineReservationDB;
GO
-- ============================================================================
-- Trigger: trg_PreventDuplicateSeat
-- Description: Prevents duplicate seat assignment for the same flight schedule.
-- ============================================================================
CREATE OR ALTER TRIGGER trg_PreventDuplicateSeat
ON Ticket
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM Ticket T
        INNER JOIN inserted I
            ON T.ScheduleID = I.ScheduleID
           AND T.SeatNumber = I.SeatNumber
           AND T.TicketID <> I.TicketID
    )
    BEGIN
        RAISERROR('Seat is already booked for this flight.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO


-- =========================================================
-- 2. Passenger Update Audit
-- =========================================================

CREATE OR ALTER TRIGGER trg_LogPassengerUpdate
ON Passenger
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO PassengerAudit
    (
        PassengerID,
        OldFirstName,
        NewFirstName,
        OldLastName,
        NewLastName,
        UpdatedDate
    )
    SELECT
        d.PassengerID,
        d.FirstName,
        i.FirstName,
        d.LastName,
        i.LastName,
        GETDATE()
    FROM deleted d
    INNER JOIN inserted i
        ON d.PassengerID = i.PassengerID;
END;
GO


-- =========================================================
-- 3. Payment Audit
-- =========================================================

CREATE TABLE PaymentAudit
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentID INT NOT NULL,
    BookingID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    Amount DECIMAL(10,2) NOT NULL,
    TransactionNo VARCHAR(100) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    AuditDate DATETIME NOT NULL DEFAULT(GETDATE())
);
GO


CREATE OR ALTER TRIGGER trg_AuditPayment
ON Payment
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO PaymentAudit
    (
        PaymentID,
        BookingID,
        PaymentMethodID,
        Amount,
        TransactionNo,
        Status,
        AuditDate
    )
    SELECT
        i.PaymentID,
        i.BookingID,
        i.PaymentMethodID,
        i.Amount,
        i.TransactionNo,
        i.Status,
        GETDATE()
    FROM inserted i;
END;
GO


-- =========================================================
-- 4. Cancellation Audit
-- =========================================================

CREATE TABLE CancellationAudit
(
    AuditID INT IDENTITY(1,1) PRIMARY KEY,
    CancellationID INT NOT NULL,
    TicketID INT NOT NULL,
    RefundAmount DECIMAL(10,2),
    Status VARCHAR(20),
    AuditDate DATETIME NOT NULL DEFAULT(GETDATE())
);
GO


CREATE OR ALTER TRIGGER trg_CancellationAudit
ON Cancellation
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    INSERT INTO CancellationAudit
    (
        CancellationID,
        TicketID,
        RefundAmount,
        Status,
        AuditDate
    )
    SELECT
        i.CancellationID,
        i.TicketID,
        i.RefundAmount,
        i.Status,
        GETDATE()
    FROM inserted i;
END;
GO


-- =========================================================
-- 5. Prevent Flight Deletion When Schedules Exist
-- =========================================================

CREATE OR ALTER TRIGGER trg_PreventFlightDeletion
ON Flight
INSTEAD OF DELETE
AS
BEGIN
    SET NOCOUNT ON;

    IF EXISTS
    (
        SELECT 1
        FROM FlightSchedule FS
        INNER JOIN deleted D
            ON FS.FlightID = D.FlightID
    )
    BEGIN
        RAISERROR(
            'Cannot delete flight: associated flight schedules exist.',
            16,
            1
        );
    END
    ELSE
    BEGIN
        DELETE FROM Flight
        WHERE FlightID IN
        (
            SELECT FlightID
            FROM deleted
        );
    END
END;
GO