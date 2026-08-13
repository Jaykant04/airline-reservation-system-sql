/****************************************************************************************
 Project      : Airline Reservation Management System
 Module       : Advanced Database Systems
 File         : 02_Master_Tables.sql
 Description  : Creation of all Master Tables
 Database     : AirlineReservationDB

 Developed By : Jaykant Sah (NP069676)
 Version      : 1.0
 Date         : 2026

****************************************************************************************/

USE AirlineReservationDB;
GO
SELECT name
FROM sys.databases
WHERE name='AirlineReservationDB';
GO
-- ============================================================================
-- Table: Airline
-- Description: Stores airline company information
-- ============================================================================

CREATE TABLE Airline
(
    AirlineID INT IDENTITY(1,1) NOT NULL,

    AirlineCode VARCHAR(10) NOT NULL,

    AirlineName VARCHAR(100) NOT NULL,

    Country VARCHAR(100) NOT NULL,

    ContactNumber VARCHAR(20) NULL,

    Email VARCHAR(100) NULL,

    Website VARCHAR(150) NULL,

    Status VARCHAR(20) NOT NULL
        CONSTRAINT DF_Airline_Status
        DEFAULT ('Active'),

    CreatedDate DATETIME NOT NULL
        CONSTRAINT DF_Airline_CreatedDate
        DEFAULT (GETDATE()),

    CONSTRAINT PK_Airline
        PRIMARY KEY (AirlineID),

    CONSTRAINT UQ_Airline_Code
        UNIQUE (AirlineCode),

    CONSTRAINT UQ_Airline_Name
        UNIQUE (AirlineName),

    CONSTRAINT CK_Airline_Status
        CHECK (Status IN ('Active','Inactive'))
);
GO
-- ============================================================================
-- Table: Airport
-- Description: Stores airport information
-- ============================================================================

CREATE TABLE Airport
(
    AirportID INT IDENTITY(1,1) NOT NULL,

    AirportCode VARCHAR(10) NOT NULL,

    AirportName VARCHAR(150) NOT NULL,

    City VARCHAR(100) NOT NULL,

    Country VARCHAR(100) NOT NULL,

    CreatedDate DATETIME NOT NULL
        CONSTRAINT DF_Airport_CreatedDate
        DEFAULT(GETDATE()),

    CONSTRAINT PK_Airport
        PRIMARY KEY (AirportID),

    CONSTRAINT UQ_Airport_Code
        UNIQUE (AirportCode)
);
GO


-- ============================================================================
-- Table: PassengerCategory
-- Description: Stores passenger categories
-- ============================================================================

CREATE TABLE PassengerCategory
(
    CategoryID INT IDENTITY(1,1) NOT NULL,

    CategoryName VARCHAR(50) NOT NULL,

    MinAge INT NOT NULL,

    MaxAge INT NOT NULL,

    CONSTRAINT PK_PassengerCategory
        PRIMARY KEY (CategoryID),

    CONSTRAINT UQ_PassengerCategory_Name
        UNIQUE(CategoryName),

    CONSTRAINT CK_PassengerCategory_Age
        CHECK (MinAge >= 0 AND MaxAge >= MinAge)
);
GO


-- ============================================================================
-- Table: JourneyType
-- Description: Stores available journey types
-- ============================================================================

CREATE TABLE JourneyType
(
    JourneyTypeID INT IDENTITY(1,1) NOT NULL,

    JourneyTypeName VARCHAR(50) NOT NULL,

    Description VARCHAR(255) NULL,

    CONSTRAINT PK_JourneyType
        PRIMARY KEY (JourneyTypeID),

    CONSTRAINT UQ_JourneyType_Name
        UNIQUE(JourneyTypeName)
);
GO


-- ============================================================================
-- Table: ReservationStatus
-- Description: Stores booking status
-- ============================================================================

CREATE TABLE ReservationStatus
(
    StatusID INT IDENTITY(1,1) NOT NULL,

    StatusName VARCHAR(30) NOT NULL,

    Description VARCHAR(255) NULL,

    CONSTRAINT PK_ReservationStatus
        PRIMARY KEY(StatusID),

    CONSTRAINT UQ_ReservationStatus_Name
        UNIQUE(StatusName)
);
GO


-- ============================================================================
-- Table: PaymentMethod
-- Description: Stores payment methods
-- ============================================================================

CREATE TABLE PaymentMethod
(
    PaymentMethodID INT IDENTITY(1,1) NOT NULL,

    MethodName VARCHAR(50) NOT NULL,

    Description VARCHAR(255) NULL,

    CONSTRAINT PK_PaymentMethod
        PRIMARY KEY(PaymentMethodID),

    CONSTRAINT UQ_PaymentMethod_Name
        UNIQUE(MethodName)
);
GO
-- ============================================================================
-- Table: FlightClass
-- Description: Stores available flight classes
-- ============================================================================

CREATE TABLE FlightClass
(
    ClassID INT IDENTITY(1,1) NOT NULL,

    ClassName VARCHAR(50) NOT NULL,

    Description VARCHAR(255) NULL,

    CONSTRAINT PK_FlightClass
        PRIMARY KEY (ClassID),

    CONSTRAINT UQ_FlightClass_Name
        UNIQUE (ClassName)
);
GO


-- ============================================================================
-- Table: Meal
-- Description: Stores meal information
-- ============================================================================

CREATE TABLE Meal
(
    MealID INT IDENTITY(1,1) NOT NULL,

    MealName VARCHAR(100) NOT NULL,

    MealType VARCHAR(50) NOT NULL,

    Price DECIMAL(10,2) NOT NULL,

    Description VARCHAR(255) NULL,

    CONSTRAINT PK_Meal
        PRIMARY KEY (MealID),

    CONSTRAINT UQ_Meal_Name
        UNIQUE (MealName),

    CONSTRAINT CK_Meal_Price
        CHECK (Price >= 0)
);
GO


-- ============================================================================
-- Table: BaggageType
-- Description: Stores baggage types
-- ============================================================================

CREATE TABLE BaggageType
(
    BaggageTypeID INT IDENTITY(1,1) NOT NULL,

    BaggageName VARCHAR(100) NOT NULL,

    WeightKG DECIMAL(5,2) NOT NULL,

    Price DECIMAL(10,2) NOT NULL,

    Description VARCHAR(255) NULL,

    CONSTRAINT PK_BaggageType
        PRIMARY KEY (BaggageTypeID),

    CONSTRAINT UQ_BaggageType_Name
        UNIQUE (BaggageName),

    CONSTRAINT CK_Baggage_Weight
        CHECK (WeightKG > 0),

    CONSTRAINT CK_Baggage_Price
        CHECK (Price >= 0)
);
GO


-- ============================================================================
-- Table: SpecialService
-- Description: Stores special passenger services
-- ============================================================================

CREATE TABLE SpecialService
(
    ServiceID INT IDENTITY(1,1) NOT NULL,

    ServiceName VARCHAR(100) NOT NULL,

    Price DECIMAL(10,2) NOT NULL,

    Description VARCHAR(255) NULL,

    CONSTRAINT PK_SpecialService
        PRIMARY KEY (ServiceID),

    CONSTRAINT UQ_SpecialService_Name
        UNIQUE (ServiceName),

    CONSTRAINT CK_Service_Price
        CHECK (Price >= 0)
);
GO


-- ============================================================================
-- Table: Aircraft
-- Description: Stores aircraft information
-- ============================================================================

CREATE TABLE Aircraft
(
    AircraftID INT IDENTITY(1,1) NOT NULL,

    AirlineID INT NOT NULL,

    AircraftModel VARCHAR(100) NOT NULL,

    RegistrationNumber VARCHAR(30) NOT NULL,

    SeatCapacity INT NOT NULL,

    ManufactureYear INT NOT NULL,

    Status VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Aircraft
        PRIMARY KEY (AircraftID),

    CONSTRAINT FK_Aircraft_Airline
        FOREIGN KEY (AirlineID)
        REFERENCES Airline(AirlineID),

    CONSTRAINT UQ_Aircraft_Registration
        UNIQUE (RegistrationNumber),

    CONSTRAINT CK_Aircraft_SeatCapacity
        CHECK (SeatCapacity > 0),

    CONSTRAINT CK_Aircraft_ManufactureYear
        CHECK (ManufactureYear >= 1950),

    CONSTRAINT CK_Aircraft_Status
        CHECK (Status IN ('Active','Maintenance','Retired'))
);
GO
-- ============================================================================
-- Table: Flight
-- Description: Stores flight information
-- ============================================================================

CREATE TABLE Flight
(
    FlightID INT IDENTITY(1,1) NOT NULL,

    AirlineID INT NOT NULL,

    AircraftID INT NOT NULL,

    FlightNumber VARCHAR(20) NOT NULL,

    FlightDuration INT NOT NULL,

    Status VARCHAR(20) NOT NULL,

    CONSTRAINT PK_Flight
        PRIMARY KEY (FlightID),

    CONSTRAINT FK_Flight_Airline
        FOREIGN KEY (AirlineID)
        REFERENCES Airline(AirlineID),

    CONSTRAINT FK_Flight_Aircraft
        FOREIGN KEY (AircraftID)
        REFERENCES Aircraft(AircraftID),

    CONSTRAINT UQ_Flight_Number
        UNIQUE (FlightNumber),

    CONSTRAINT CK_Flight_Duration
        CHECK (FlightDuration > 0),

    CONSTRAINT CK_Flight_Status
        CHECK (Status IN ('Scheduled','Delayed','Cancelled','Completed'))
);
GO


-- ============================================================================
-- Table: FlightSchedule
-- Description: Stores flight schedules
-- ============================================================================

CREATE TABLE FlightSchedule
(
    ScheduleID INT IDENTITY(1,1) NOT NULL,

    FlightID INT NOT NULL,

    DepartureAirportID INT NOT NULL,

    ArrivalAirportID INT NOT NULL,

    DepartureDateTime DATETIME NOT NULL,

    ArrivalDateTime DATETIME NOT NULL,

    AvailableSeats INT NOT NULL,

    CONSTRAINT PK_FlightSchedule
        PRIMARY KEY (ScheduleID),

    CONSTRAINT FK_FlightSchedule_Flight
        FOREIGN KEY (FlightID)
        REFERENCES Flight(FlightID),

    CONSTRAINT FK_FlightSchedule_DepartureAirport
        FOREIGN KEY (DepartureAirportID)
        REFERENCES Airport(AirportID),

    CONSTRAINT FK_FlightSchedule_ArrivalAirport
        FOREIGN KEY (ArrivalAirportID)
        REFERENCES Airport(AirportID),

    CONSTRAINT CK_FlightSchedule_Seats
        CHECK (AvailableSeats >= 0),

    CONSTRAINT CK_FlightSchedule_Time
        CHECK (ArrivalDateTime > DepartureDateTime),

    CONSTRAINT CK_FlightSchedule_DifferentAirports
        CHECK (DepartureAirportID <> ArrivalAirportID)
);
GO


-- ============================================================================
-- Table: FlightClassFare
-- Description: Stores fares for each class on each flight schedule
-- ============================================================================

CREATE TABLE FlightClassFare
(
    FareID INT IDENTITY(1,1) NOT NULL,

    ScheduleID INT NOT NULL,

    ClassID INT NOT NULL,

    FareAmount DECIMAL(10,2) NOT NULL,

    Currency VARCHAR(10) NOT NULL,

    CONSTRAINT PK_FlightClassFare
        PRIMARY KEY (FareID),

    CONSTRAINT FK_FlightClassFare_Schedule
        FOREIGN KEY (ScheduleID)
        REFERENCES FlightSchedule(ScheduleID),

    CONSTRAINT FK_FlightClassFare_Class
        FOREIGN KEY (ClassID)
        REFERENCES FlightClass(ClassID),

    CONSTRAINT UQ_FlightClassFare
        UNIQUE (ScheduleID, ClassID),

    CONSTRAINT CK_FlightClassFare_Amount
        CHECK (FareAmount > 0)
);
GO

USE AirlineReservationDB;
GO

SELECT TABLE_NAME
FROM INFORMATION_SCHEMA.TABLES
WHERE TABLE_TYPE = 'BASE TABLE'
ORDER BY TABLE_NAME;