/****************************************************************************************
 Project      : Airline Reservation Management System
 Module       : Advanced Database Systems
 File         : 03_Transaction_Tables.sql
 Description  : Creation of all Transaction Tables
 Database     : AirlineReservationDB

 Developed By : Jaykant Sah (NP069676)
 Version      : 1.0
 Date         : 2026
****************************************************************************************/

USE AirlineReservationDB;
GO
-- ============================================================================
-- Table: Passenger
-- Description: Stores passenger personal information
-- ============================================================================

CREATE TABLE Passenger
(
    PassengerID INT IDENTITY(1,1) NOT NULL,

    CategoryID INT NOT NULL,

    FirstName VARCHAR(50) NOT NULL,

    LastName VARCHAR(50) NOT NULL,

    Gender VARCHAR(10) NOT NULL,

    DateOfBirth DATE NOT NULL,

    PassportNumber VARCHAR(20) NOT NULL,

    Nationality VARCHAR(50) NOT NULL,

    PhoneNumber VARCHAR(20) NULL,

    Email VARCHAR(100) NULL,

    Address VARCHAR(255) NULL,

    CONSTRAINT PK_Passenger
        PRIMARY KEY (PassengerID),

    CONSTRAINT FK_Passenger_Category
        FOREIGN KEY (CategoryID)
        REFERENCES PassengerCategory(CategoryID),

    CONSTRAINT UQ_Passenger_Passport
        UNIQUE (PassportNumber),

    CONSTRAINT UQ_Passenger_Email
        UNIQUE (Email),

    CONSTRAINT CK_Passenger_Gender
        CHECK (Gender IN ('Male','Female','Other'))
);
GO
-- ============================================================================
-- Table: Booking
-- Description: Stores booking information
-- ============================================================================

CREATE TABLE Booking
(
    BookingID INT IDENTITY(1,1) NOT NULL,

    JourneyTypeID INT NOT NULL,

    StatusID INT NOT NULL,

    BookingReference VARCHAR(20) NOT NULL,

    BookingDate DATETIME NOT NULL
        DEFAULT(GETDATE()),

    TotalAmount DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_Booking
        PRIMARY KEY (BookingID),

    CONSTRAINT FK_Booking_JourneyType
        FOREIGN KEY (JourneyTypeID)
        REFERENCES JourneyType(JourneyTypeID),

    CONSTRAINT FK_Booking_Status
        FOREIGN KEY (StatusID)
        REFERENCES ReservationStatus(StatusID),

    CONSTRAINT UQ_Booking_Reference
        UNIQUE (BookingReference),

    CONSTRAINT CK_Booking_Total
        CHECK (TotalAmount >= 0)
);
GO
-- ============================================================================
-- Table: BookingPassenger
-- Description: Junction table between Booking and Passenger
-- ============================================================================

CREATE TABLE BookingPassenger
(
    BookingPassengerID INT IDENTITY(1,1) NOT NULL,

    BookingID INT NOT NULL,

    PassengerID INT NOT NULL,

    CONSTRAINT PK_BookingPassenger
        PRIMARY KEY (BookingPassengerID),

    CONSTRAINT FK_BP_Booking
        FOREIGN KEY (BookingID)
        REFERENCES Booking(BookingID),

    CONSTRAINT FK_BP_Passenger
        FOREIGN KEY (PassengerID)
        REFERENCES Passenger(PassengerID),

    CONSTRAINT UQ_BookingPassenger
        UNIQUE (BookingID, PassengerID)
);
GO
-- ============================================================================
-- Table: Ticket
-- Description: Stores issued airline tickets
-- ============================================================================

CREATE TABLE Ticket
(
    TicketID INT IDENTITY(1,1) NOT NULL,

    BookingID INT NOT NULL,

    ScheduleID INT NOT NULL,

    ClassID INT NOT NULL,

    TicketNumber VARCHAR(30) NOT NULL,

    SeatNumber VARCHAR(10) NOT NULL,

    TicketPrice DECIMAL(10,2) NOT NULL,

    IssueDate DATE NOT NULL
        CONSTRAINT DF_Ticket_IssueDate DEFAULT GETDATE(),

    CONSTRAINT PK_Ticket
        PRIMARY KEY (TicketID),

    CONSTRAINT FK_Ticket_Booking
        FOREIGN KEY (BookingID)
        REFERENCES Booking(BookingID),

    CONSTRAINT FK_Ticket_FlightSchedule
        FOREIGN KEY (ScheduleID)
        REFERENCES FlightSchedule(ScheduleID),

    CONSTRAINT FK_Ticket_FlightClass
        FOREIGN KEY (ClassID)
        REFERENCES FlightClass(ClassID),

    CONSTRAINT UQ_Ticket_Number
        UNIQUE (TicketNumber),

    CONSTRAINT UQ_Ticket_Seat
        UNIQUE (ScheduleID, SeatNumber),

    CONSTRAINT CK_Ticket_Price
        CHECK (TicketPrice >= 0)
);
GO
-- ============================================================================
-- Table: Payment
-- Description: Stores payment information
-- ============================================================================

CREATE TABLE Payment
(
    PaymentID INT IDENTITY(1,1) NOT NULL,

    BookingID INT NOT NULL,

    PaymentMethodID INT NOT NULL,

    PaymentDate DATETIME NOT NULL
        DEFAULT(GETDATE()),

    Amount DECIMAL(10,2) NOT NULL,

    TransactionNo VARCHAR(100) NOT NULL,

    Status VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Payment
        PRIMARY KEY (PaymentID),

    CONSTRAINT FK_Payment_Booking
        FOREIGN KEY (BookingID)
        REFERENCES Booking(BookingID),

    CONSTRAINT FK_Payment_Method
        FOREIGN KEY (PaymentMethodID)
        REFERENCES PaymentMethod(PaymentMethodID),

    CONSTRAINT UQ_TransactionNo
        UNIQUE (TransactionNo),

    CONSTRAINT CK_Payment_Amount
        CHECK (Amount >= 0),

    CONSTRAINT CK_Payment_Status
        CHECK (Status IN ('Pending','Completed','Failed','Refunded'))
);
GO
-- ============================================================================
-- Table: FlightMeal
-- Description: Meals available for a flight schedule
-- ============================================================================

CREATE TABLE FlightMeal
(
    FlightMealID INT IDENTITY(1,1) NOT NULL,

    ScheduleID INT NOT NULL,

    MealID INT NOT NULL,

    Price DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_FlightMeal
        PRIMARY KEY (FlightMealID),

    CONSTRAINT FK_FlightMeal_Schedule
        FOREIGN KEY (ScheduleID)
        REFERENCES FlightSchedule(ScheduleID),

    CONSTRAINT FK_FlightMeal_Meal
        FOREIGN KEY (MealID)
        REFERENCES Meal(MealID),

    CONSTRAINT UQ_FlightMeal
        UNIQUE (ScheduleID, MealID),

    CONSTRAINT CK_FlightMeal_Price
        CHECK (Price >= 0)
);
GO
-- ============================================================================
-- Table: PassengerMeal
-- Description: Meal selected by passenger
-- ============================================================================

CREATE TABLE PassengerMeal
(
    PassengerMealID INT IDENTITY(1,1) NOT NULL,

    TicketID INT NOT NULL,

    MealID INT NOT NULL,

    Quantity INT NOT NULL DEFAULT 1,

    Price DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_PassengerMeal
        PRIMARY KEY (PassengerMealID),

    CONSTRAINT FK_PassengerMeal_Ticket
        FOREIGN KEY (TicketID)
        REFERENCES Ticket(TicketID),

    CONSTRAINT FK_PassengerMeal_Meal
        FOREIGN KEY (MealID)
        REFERENCES Meal(MealID),

    CONSTRAINT UQ_PassengerMeal
        UNIQUE (TicketID, MealID),

    CONSTRAINT CK_PassengerMeal_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT CK_PassengerMeal_Price
        CHECK (Price >= 0)
);
GO
-- ============================================================================
-- Table: PassengerBaggage
-- Description: Baggage selected by passenger
-- ============================================================================

CREATE TABLE PassengerBaggage
(
    PassengerBaggageID INT IDENTITY(1,1) NOT NULL,

    TicketID INT NOT NULL,

    BaggageTypeID INT NOT NULL,

    Quantity INT NOT NULL DEFAULT 1,

    Price DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_PassengerBaggage
        PRIMARY KEY (PassengerBaggageID),

    CONSTRAINT FK_PassengerBaggage_Ticket
        FOREIGN KEY (TicketID)
        REFERENCES Ticket(TicketID),

    CONSTRAINT FK_PassengerBaggage_Baggage
        FOREIGN KEY (BaggageTypeID)
        REFERENCES BaggageType(BaggageTypeID),

    CONSTRAINT UQ_PassengerBaggage
        UNIQUE (TicketID, BaggageTypeID),

    CONSTRAINT CK_PassengerBaggage_Quantity
        CHECK (Quantity > 0),

    CONSTRAINT CK_PassengerBaggage_Price
        CHECK (Price >= 0)
);
GO
-- ============================================================================
-- Table: PassengerSpecialService
-- Description: Special services selected by passenger
-- ============================================================================

CREATE TABLE PassengerSpecialService
(
    PassengerServiceID INT IDENTITY(1,1) NOT NULL,

    TicketID INT NOT NULL,

    ServiceID INT NOT NULL,

    Price DECIMAL(10,2) NOT NULL,

    CONSTRAINT PK_PassengerSpecialService
        PRIMARY KEY (PassengerServiceID),

    CONSTRAINT FK_PassengerSpecialService_Ticket
        FOREIGN KEY (TicketID)
        REFERENCES Ticket(TicketID),

    CONSTRAINT FK_PassengerSpecialService_Service
        FOREIGN KEY (ServiceID)
        REFERENCES SpecialService(ServiceID),

    CONSTRAINT UQ_PassengerService
        UNIQUE (TicketID, ServiceID),

    CONSTRAINT CK_PassengerService_Price
        CHECK (Price >= 0)
);
GO
-- ============================================================================
-- Table: CreditAccount
-- Description: Passenger credit wallet
-- ============================================================================

CREATE TABLE CreditAccount
(
    CreditAccountID INT IDENTITY(1,1) NOT NULL,

    PassengerID INT NOT NULL,

    CreditLimit DECIMAL(10,2) NOT NULL,

    AvailableCredit DECIMAL(10,2) NOT NULL,

    OpenDate DATE NOT NULL,

    Status VARCHAR(20) NOT NULL,

    CONSTRAINT PK_CreditAccount
        PRIMARY KEY (CreditAccountID),

    CONSTRAINT FK_CreditAccount_Passenger
        FOREIGN KEY (PassengerID)
        REFERENCES Passenger(PassengerID),

    CONSTRAINT CK_CreditLimit
        CHECK (CreditLimit >= 0),

    CONSTRAINT CK_AvailableCredit
        CHECK (AvailableCredit >= 0),

    CONSTRAINT CK_Credit_Status
        CHECK (Status IN ('Active','Inactive','Suspended'))
);
GO
-- ============================================================================
-- Table: Cancellation
-- Description: Ticket cancellation records
-- ============================================================================

CREATE TABLE Cancellation
(
    CancellationID INT IDENTITY(1,1) NOT NULL,

    TicketID INT NOT NULL,

    CancellationDate DATETIME NOT NULL DEFAULT(GETDATE()),

    RefundAmount DECIMAL(10,2) NOT NULL,

    Reason VARCHAR(255) NULL,

    Status VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Cancellation
        PRIMARY KEY (CancellationID),

    CONSTRAINT FK_Cancellation_Ticket
        FOREIGN KEY (TicketID)
        REFERENCES Ticket(TicketID),

    CONSTRAINT CK_Cancellation_Refund
        CHECK (RefundAmount >= 0),

    CONSTRAINT CK_Cancellation_Status
        CHECK (Status IN ('Pending','Approved','Rejected'))
);
GO
-- ============================================================================
-- Table: Reschedule
-- Description: Ticket rescheduling records
-- ============================================================================

CREATE TABLE Reschedule
(
    RescheduleID INT IDENTITY(1,1) NOT NULL,

    TicketID INT NOT NULL,

    OldScheduleID INT NOT NULL,

    NewScheduleID INT NOT NULL,

    RescheduleDate DATETIME NOT NULL DEFAULT(GETDATE()),

    FareDifference DECIMAL(10,2) NOT NULL,

    Status VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Reschedule
        PRIMARY KEY (RescheduleID),

    CONSTRAINT FK_Reschedule_Ticket
        FOREIGN KEY (TicketID)
        REFERENCES Ticket(TicketID),

    CONSTRAINT FK_Reschedule_OldSchedule
        FOREIGN KEY (OldScheduleID)
        REFERENCES FlightSchedule(ScheduleID),

    CONSTRAINT FK_Reschedule_NewSchedule
        FOREIGN KEY (NewScheduleID)
        REFERENCES FlightSchedule(ScheduleID),

    CONSTRAINT CK_Reschedule_Fare
        CHECK (FareDifference >= 0),

    CONSTRAINT CK_Reschedule_Status
        CHECK (Status IN ('Pending','Approved','Rejected')),

    CONSTRAINT CK_Reschedule_DifferentSchedule
        CHECK (OldScheduleID <> NewScheduleID)
);
GO
-- Reschedule adding  "RescheduleFee" and Reason"
ALTER TABLE Reschedule
ADD
    RescheduleFee DECIMAL(10,2) NOT NULL DEFAULT 0,
    Reason VARCHAR(255) NULL;
GO