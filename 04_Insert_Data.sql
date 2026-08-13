/****************************************************************************************
 Project      : Airline Reservation Management System
 Module       : Advanced Database Systems
 File         : 04_Insert_Data.sql
 Description  : Insert Sample Data
 Database     : AirlineReservationDB
  Developed By : Jaykant Sah (NP069676)
****************************************************************************************/

USE AirlineReservationDB;
GO
INSERT INTO Airline
(AirlineCode, AirlineName, Country, ContactNumber, Email, Website, Status)
VALUES
('YT','Yeti Airlines','Nepal','+977-1-4410900','info@yeti.com','www.yetiairlines.com','Active'),
('NA','Nepal Airlines','Nepal','+977-1-4220757','info@nepalairlines.com','www.nepalairlines.com','Active'),
('QR','Qatar Airways','Qatar','+974-40230000','info@qatarairways.com','www.qatarairways.com','Active'),
('EK','Emirates','UAE','+971-600555555','info@emirates.com','www.emirates.com','Active'),
('AI','Air India','India','+91-1242641407','info@airindia.com','www.airindia.com','Active');
GO
INSERT INTO Airport
(AirportCode, AirportName, City, Country)
VALUES
('KTM','Tribhuvan International Airport','Kathmandu','Nepal'),
('PKR','Pokhara International Airport','Pokhara','Nepal'),
('BWA','Gautam Buddha International Airport','Bhairahawa','Nepal'),
('DEL','Indira Gandhi International Airport','Delhi','India'),
('DXB','Dubai International Airport','Dubai','UAE'),
('DOH','Hamad International Airport','Doha','Qatar'),
('BOM','Chhatrapati Shivaji Airport','Mumbai','India'),
('SIN','Singapore Changi Airport','Singapore','Singapore');
GO
INSERT INTO PassengerCategory
(CategoryName, MinAge, MaxAge)
VALUES
('Infant',0,2),
('Child',3,11),
('Adult',12,59),
('Senior Citizen',60,120);
GO
INSERT INTO JourneyType
(JourneyTypeName, Description)
VALUES
('One Way','Single trip'),
('Round Trip','Return journey'),
('Multi City','Multiple destinations');
GO
INSERT INTO ReservationStatus
(StatusName, Description)
VALUES
('Pending','Awaiting confirmation'),
('Confirmed','Booking confirmed'),
('Cancelled','Booking cancelled'),
('Completed','Journey completed');
GO
INSERT INTO PaymentMethod
(MethodName, Description)
VALUES
('Cash','Cash Payment'),
('Credit Card','Visa or MasterCard'),
('Debit Card','Bank Debit Card'),
('eSewa','Nepal Digital Wallet'),
('Khalti','Digital Wallet'),
('FonePay','FonePay Payment');
GO
INSERT INTO FlightClass
(ClassName, Description)
VALUES
('Economy','Standard Class'),
('Premium Economy','Extra Legroom'),
('Business','Business Class'),
('First','Luxury Class');
GO
INSERT INTO Meal
(MealName, MealType, Price, Description)
VALUES
('Veg Meal','Vegetarian',12.00,'Vegetarian Food'),
('Chicken Meal','Non-Veg',15.00,'Chicken Meal'),
('Seafood Meal','Non-Veg',18.00,'Seafood'),
('Vegan Meal','Vegan',13.50,'Plant Based'),
('Kids Meal','Special',10.00,'Children Meal');
GO
INSERT INTO BaggageType
(BaggageName, WeightKG, Price, Description)
VALUES
('15 KG',15,0,'Free'),
('20 KG',20,15,'Extra'),
('25 KG',25,30,'Extra'),
('30 KG',30,50,'Heavy');
GO
INSERT INTO SpecialService
(ServiceName, Price, Description)
VALUES
('Wheelchair',0,'Special Assistance'),
('Extra Legroom',30,'Premium Seat'),
('Priority Boarding',20,'Fast Boarding'),
('Special Assistance',15,'Medical Support');
GO
INSERT INTO Aircraft
(AirlineID, AircraftModel, RegistrationNumber, SeatCapacity, ManufactureYear, Status)
VALUES
(1,'ATR 72-500','9N-ANC',72,2018,'Active'),
(2,'Airbus A320','9N-AKW',158,2019,'Active'),
(3,'Boeing 777-300ER','A7-BOE',396,2020,'Active'),
(4,'Airbus A380','A6-EDA',517,2021,'Active'),
(5,'Airbus A321','VT-EXA',182,2022,'Active');
GO
INSERT INTO Flight
(AirlineID, AircraftID, FlightNumber, FlightDuration, Status)
VALUES
(1,1,'YT101',35,'Scheduled'),
(2,2,'RA205',90,'Scheduled'),
(3,3,'QR652',240,'Scheduled'),
(4,4,'EK215',300,'Scheduled'),
(5,5,'AI214',120,'Scheduled');
GO
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
(1,1,2,'2026-08-01 08:00','2026-08-01 08:35',72),
(2,1,4,'2026-08-02 09:00','2026-08-02 10:30',158),
(3,6,1,'2026-08-03 11:00','2026-08-03 15:00',396),
(4,5,1,'2026-08-04 14:00','2026-08-04 19:00',517),
(5,4,1,'2026-08-05 07:30','2026-08-05 09:30',182);
GO
INSERT INTO FlightClassFare
(ScheduleID, ClassID, FareAmount, Currency)
VALUES
(1,1,80,'USD'),
(1,2,120,'USD'),
(1,3,180,'USD'),
(1,4,250,'USD'),

(2,1,150,'USD'),
(2,2,220,'USD'),
(2,3,320,'USD'),
(2,4,450,'USD'),

(3,1,450,'USD'),
(3,2,650,'USD'),
(3,3,950,'USD'),
(3,4,1400,'USD'),

(4,1,550,'USD'),
(4,2,780,'USD'),
(4,3,1200,'USD'),
(4,4,1800,'USD'),

(5,1,180,'USD'),
(5,2,260,'USD'),
(5,3,390,'USD'),
(5,4,550,'USD');
GO
INSERT INTO Passenger
(CategoryID, FirstName, LastName, Gender, DateOfBirth, PassportNumber, Nationality, PhoneNumber, Email, Address)
VALUES
(3,'Ram','Sharma','Male','1995-05-15','NP123456','Nepali','9800000001','ram@gmail.com','Kathmandu'),
(3,'Sita','Khadka','Female','1998-08-10','NP123457','Nepali','9800000002','sita@gmail.com','Pokhara'),
(2,'Hari','Thapa','Male','2016-01-20','NP123458','Nepali','9800000003','hari@gmail.com','Chitwan'),
(4,'Gita','Rai','Female','1962-11-11','NP123459','Nepali','9800000004','gita@gmail.com','Butwal'),
(3,'John','Smith','Male','1990-09-09','US123456','American','9800000005','john@gmail.com','New York');
GO
INSERT INTO Booking
(JourneyTypeID, StatusID, BookingReference, BookingDate, TotalAmount)
VALUES
(1,2,'BK1001','2026-07-20',180),
(2,2,'BK1002','2026-07-20',650),
(1,1,'BK1003','2026-07-21',320),
(2,2,'BK1004','2026-07-22',1200),
(1,2,'BK1005','2026-07-23',390);
GO
INSERT INTO BookingPassenger
(BookingID, PassengerID)
VALUES
(1,1),
(2,2),
(3,3),
(4,4),
(5,5);
GO
INSERT INTO Ticket
(BookingID, ScheduleID, ClassID, TicketNumber, SeatNumber, TicketPrice)
VALUES
(1,1,1,'TK100001','12A',80),
(2,2,2,'TK100002','05B',220),
(3,3,3,'TK100003','03A',950),
(4,4,4,'TK100004','01A',1800),
(5,5,2,'TK100005','08C',260);
GO
INSERT INTO Payment
(BookingID, PaymentMethodID, PaymentDate, Amount, TransactionNo, Status)
VALUES
(1,4,GETDATE(),180,'TXN100001','Completed'),
(2,2,GETDATE(),650,'TXN100002','Completed'),
(3,5,GETDATE(),320,'TXN100003','Pending'),
(4,3,GETDATE(),1200,'TXN100004','Completed'),
(5,1,GETDATE(),390,'TXN100005','Completed');
GO
INSERT INTO FlightMeal
(ScheduleID, MealID, Price)
VALUES
(1,1,12),
(2,2,15),
(3,3,18),
(4,4,14),
(5,5,10);
GO
INSERT INTO PassengerMeal
(TicketID, MealID, Quantity, Price)
VALUES
(1,1,1,12),
(2,2,1,15),
(3,3,1,18),
(4,4,2,28),
(5,5,1,10);
GO
INSERT INTO PassengerBaggage
(TicketID, BaggageTypeID, Quantity, Price)
VALUES
(1,1,1,0),
(2,2,1,15),
(3,3,1,30),
(4,4,2,100),
(5,2,1,15);
GO
INSERT INTO PassengerSpecialService
(TicketID, ServiceID, Price)
VALUES
(1,1,0),
(2,2,30),
(3,3,20),
(4,4,15),
(5,2,30);
GO
INSERT INTO CreditAccount
(PassengerID, CreditLimit, AvailableCredit, OpenDate, Status)
VALUES
(1,5000,4200,'2026-01-01','Active'),
(2,3000,2500,'2026-02-15','Active'),
(3,2000,2000,'2026-03-10','Active'),
(4,4000,3500,'2026-01-20','Active'),
(5,6000,5200,'2026-04-05','Active');
GO
INSERT INTO Cancellation
(TicketID, CancellationDate, RefundAmount, Reason, Status)
VALUES
(3,GETDATE(),250,'Passenger Request','Approved');
GO
INSERT INTO Reschedule
(TicketID, OldScheduleID, NewScheduleID, RescheduleDate, FareDifference, Status)
VALUES
(2,2,3,GETDATE(),80,'Approved');
GO