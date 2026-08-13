USE AirlineReservationDB;
GO

/*==========================================================
  FILE : 05_Insert_Data_Final.sql
  PURPOSE : Additional Sample Data
  AUTHOR : Jaykant Sah
==========================================================*/
GO
/*==========================================================
  SECTION 1 : AIRLINE
==========================================================*/

INSERT INTO Airline
(
    AirlineCode,
    AirlineName,
    Country,
    ContactNumber,
    Email,
    Website,
    Status,
    CreatedDate
)
VALUES
('BD','Buddha Air','Nepal','+977-1-5970900','info@buddhaair.com','www.buddhaair.com','Active',GETDATE()),

('SR','Shree Airlines','Nepal','+977-1-4004000','info@shreeairlines.com','www.shreeairlines.com','Active',GETDATE()),

('TA','Tara Air','Nepal','+977-1-4499000','info@taraair.com','www.taraair.com','Active',GETDATE()),

('ST','Sita Air','Nepal','+977-1-4466000','info@sitaair.com','www.sitaair.com','Active',GETDATE()),

('SM','Summit Air','Nepal','+977-1-4117000','info@summitair.com','www.summitair.com','Active',GETDATE());

GO
/*==========================================================
  SECTION 2 : AIRPORT
==========================================================*/

INSERT INTO Airport
(
    AirportCode,
    AirportName,
    City,
    Country,
    CreatedDate
)
VALUES
('BIR','Biratnagar Airport','Biratnagar','Nepal',GETDATE()),

('RJB','Rajbiraj Airport','Rajbiraj','Nepal',GETDATE()),

('JKR','Janakpur Airport','Janakpur','Nepal',GETDATE()),

('DHI','Dhangadhi Airport','Dhangadhi','Nepal',GETDATE());

GO

/*==========================================================
  SECTION 3 : AIRCRAFT
==========================================================*/

INSERT INTO Aircraft
(
    AirlineID,
    AircraftModel,
    RegistrationNumber,
    SeatCapacity,
    ManufactureYear,
    Status
)
VALUES
(6,'ATR 72-600','9N-BDA',72,2021,'Active'),

(7,'Bombardier CRJ-700','9N-SRA',78,2020,'Active'),

(8,'DHC-6 Twin Otter','9N-TAA',19,2019,'Active'),

(9,'LET L-410 UVP-E20','9N-STA',19,2018,'Active'),

(10,'ATR 42-320','9N-SMA',48,2022,'Active');

GO
/*==========================================================
  SECTION 4 : FLIGHT
==========================================================*/

INSERT INTO Flight
(
    AirlineID,
    AircraftID,
    FlightNumber,
    FlightDuration,
    Status
)
VALUES

(6,6,'BD201',45,'Scheduled'),

(7,7,'SR301',60,'Scheduled'),

(8,8,'TA401',35,'Scheduled'),

(9,9,'ST501',55,'Scheduled'),

(10,10,'SM601',50,'Scheduled');

GO
/*==========================================================
  SECTION 5 : FLIGHTSCHEDULE
==========================================================*/

INSERT INTO FlightSchedule
(
    FlightID,
    DepartureAirportID,
    ArrivalAirportID,
    DepartureDateTime,
    ArrivalDateTime,
    AvailableSeats
)
VALUES

(6,1,9,'2026-08-02 08:00:00','2026-08-02 08:45:00',72),

(7,1,10,'2026-08-02 10:00:00','2026-08-02 11:00:00',78),

(8,1,11,'2026-08-02 13:00:00','2026-08-02 13:35:00',19),

(9,1,12,'2026-08-02 15:00:00','2026-08-02 15:55:00',19),

(10,2,1,'2026-08-03 09:00:00','2026-08-03 09:50:00',48);

GO

/*==========================================================
  SECTION 6 : PASSENGER
==========================================================*/

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

(1,'Suman','Yadav','Male','1997-04-12','NP223456','Nepali','9800000002','suman.yadav@gmail.com','Janakpur'),

(1,'Roshan','Chaudhary','Male','1996-09-18','NP223457','Nepali','9800000003','roshan.c@gmail.com','Biratnagar'),

(2,'Anita','Thapa','Female','1998-11-25','NP223458','Nepali','9800000004','anita.thapa@gmail.com','Pokhara'),

(1,'Pratik','Mishra','Male','1995-07-20','NP223459','Nepali','9800000005','pratik.m@gmail.com','Rajbiraj'),

(1,'Nisha','Rai','Female','1999-02-14','NP223460','Nepali','9800000006','nisha.rai@gmail.com','Dharan'),

(3,'Aayush','Sharma','Male','2001-03-09','NP223461','Nepali','9800000007','aayush.sharma@gmail.com','Kathmandu'),

(2,'Pooja','Singh','Female','1997-12-22','NP223462','Nepali','9800000008','pooja.singh@gmail.com','Birgunj'),

(1,'Bikash','Karki','Male','1994-08-17','NP223463','Nepali','9800000009','bikash.karki@gmail.com','Nepalgunj'),

(1,'Sarina','Lama','Female','1998-06-28','NP223464','Nepali','9800000010','sarina.lama@gmail.com','Lalitpur'),

(2,'Ramesh','Shrestha','Male','1992-10-10','NP223465','Nepali','9800000011','ramesh.s@gmail.com','Bhaktapur'),

(1,'Kabita','KC','Female','1996-01-19','NP223466','Nepali','9800000012','kabita.kc@gmail.com','Dhangadhi'),

(3,'Deepak','Adhikari','Male','2000-05-05','NP223467','Nepali','9800000013','deepak.a@gmail.com','Butwal'),

(2,'Asmita','Gurung','Female','1998-08-08','NP223468','Nepali','9800000014','asmita.g@gmail.com','Pokhara'),

(1,'Nabin','Pandey','Male','1995-12-30','NP223469','Nepali','9800000015','nabin.p@gmail.com','Chitwan');

GO

/*==========================================================
  SECTION 7 : PAYMENT METHOD
==========================================================*/

INSERT INTO PaymentMethod
(
    MethodName
)
VALUES
('Google Pay'),
('PhonePe'),
('Paytm'),
('IME Pay');

GO
/*==========================================================
  SECTION 8 : MEAL
==========================================================*/

INSERT INTO Meal
(
    MealName,
    MealType,
    Price,
    Description
)
VALUES

('Nepali Thali','Vegetarian',15.00,'Traditional Nepali vegetarian meal'),

('Chicken Biryani','Non-Vegetarian',18.00,'Spicy chicken biryani with raita'),

('Veg Fried Rice','Vegetarian',12.00,'Vegetable fried rice'),

('Buff Momo','Non-Vegetarian',10.00,'Steamed buff momo'),

('Chicken Momo','Non-Vegetarian',11.00,'Steamed chicken momo'),

('Paneer Curry','Vegetarian',14.00,'Paneer curry with rice'),

('Grilled Fish','Non-Vegetarian',20.00,'Grilled fish with vegetables'),

('Pasta Alfredo','Vegetarian',16.00,'Creamy Alfredo pasta'),

('Fruit Salad','Vegetarian',8.00,'Fresh seasonal fruits'),

('Sandwich Combo','Vegetarian',9.00,'Vegetable sandwich with juice');

GO
/*==========================================================
  SECTION 9 : SPECIAL SERVICE
==========================================================*/

INSERT INTO SpecialService
(
    ServiceName,
    Price,
    Description
)
VALUES

('VIP Lounge Access',35.00,'Access to airport VIP lounge'),

('Medical Assistance',0.00,'Emergency medical assistance'),

('Pet Travel Service',40.00,'Special handling for pets'),

('Infant Care',10.00,'Special assistance for infants'),

('Unaccompanied Minor',50.00,'Support for children travelling alone'),

('Meet and Greet',25.00,'Airport meet and greet service');

GO

/*==========================================================
  SECTION 10 : BAGGAGE TYPE
==========================================================*/

INSERT INTO BaggageType
(
    BaggageName,
    WeightKG,
    Price,
    Description
)
VALUES

('35 KG',35.00,35.00,'Extra baggage allowance'),

('40 KG',40.00,45.00,'Premium baggage allowance'),

('45 KG',45.00,55.00,'Business class baggage'),

('50 KG',50.00,70.00,'Heavy baggage package'),

('Sports Equipment',25.00,60.00,'Sports equipment handling'),

('Musical Instrument',20.00,40.00,'Special handling for musical instruments');

GO
/*==========================================================
  SECTION 11 : FLIGHT CLASS FARE
  (Only Missing Records)
==========================================================*/

INSERT INTO FlightClassFare
(
    ScheduleID,
    ClassID,
    FareAmount,
    Currency
)
VALUES

-- Schedule 6
(6,1,110.00,'USD'),
(6,2,170.00,'USD'),
(6,3,260.00,'USD'),
(6,4,380.00,'USD'),

-- Schedule 7
(7,1,120.00,'USD'),
(7,2,180.00,'USD'),
(7,3,270.00,'USD'),
(7,4,390.00,'USD'),

-- Schedule 8
(8,1,130.00,'USD'),
(8,2,190.00,'USD'),
(8,3,280.00,'USD'),
(8,4,410.00,'USD'),

-- Schedule 9
(9,1,140.00,'USD'),
(9,2,200.00,'USD'),
(9,3,300.00,'USD'),
(9,4,430.00,'USD'),

-- Schedule 10
(10,1,150.00,'USD'),
(10,2,220.00,'USD'),
(10,3,320.00,'USD'),
(10,4,450.00,'USD');

GO

/*==========================================================
  SECTION 12 : FLIGHT MEAL
==========================================================*/

INSERT INTO FlightMeal
(
    ScheduleID,
    MealID,
    Price
)
VALUES

-- Schedule 6
(6,7,15.00),
(6,8,18.00),

-- Schedule 7
(7,9,12.00),
(7,10,10.00),

-- Schedule 8
(8,11,11.00),
(8,12,14.00),

-- Schedule 9
(9,13,20.00),
(9,14,16.00),

-- Schedule 10
(10,15,8.00),
(10,16,9.00);

GO
/*==========================================================
  SECTION 13 : PASSENGER MEAL
==========================================================*/

INSERT INTO PassengerMeal
(
    TicketID,
    MealID,
    Quantity,
    Price
)
VALUES
(6,7,1,15.00),
(7,8,1,18.00),
(8,9,1,12.00),
(9,10,1,10.00);

GO
/*==========================================================
  SECTION 14 : PASSENGER BAGGAGE
==========================================================*/

INSERT INTO PassengerBaggage
(
    TicketID,
    BaggageTypeID,
    Quantity,
    Price
)
VALUES

(6,6,1,35.00),
(6,7,1,45.00),

(7,8,1,55.00),
(7,9,1,70.00),

(8,10,1,60.00),
(8,11,1,40.00),

(9,6,2,70.00),
(9,7,1,45.00);

GO
/*==========================================================
  SECTION 15 : PASSENGER SPECIAL SERVICE
==========================================================*/

INSERT INTO PassengerSpecialService
(
    TicketID,
    ServiceID,
    Price
)
VALUES

(6,6,50.00),
(6,7,20.00),

(7,8,35.00),

(8,9,15.00),

(9,10,30.00),

(9,11,40.00);

GO