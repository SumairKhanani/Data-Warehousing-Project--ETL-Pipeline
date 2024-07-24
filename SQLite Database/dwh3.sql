-- Database: DWHHOTELMANGAMENT



CREATE DATABASE "DWHHOTELMANGAMENT"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'English_United States.1252'
    LC_CTYPE = 'English_United States.1252'
    LOCALE_PROVIDER = 'libc'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;
--Creation of Tables
-- Create User Table
CREATE TABLE "User" (
  UserID SERIAL PRIMARY KEY,
  Name VARCHAR(255),
  Email VARCHAR(255),
  Gender VARCHAR(10),
  Age INT,
  PhoneNumber VARCHAR(20),
  DateOfBirth DATE,
  DateJoined DATE,
  IsEmployee BOOLEAN
);
SELECT * FROM "User";
 -- Create Owner Table
CREATE TABLE "Owner" (
  OwnerId SERIAL PRIMARY KEY,
  NoOfProperties INT,
  UserID INT,
  CONSTRAINT fk_owner_user FOREIGN KEY (UserID) REFERENCES "User"(UserID)
);
SELECT * FROM "Owner";

-- Create Employee Table
CREATE TABLE "Employee" (
  EmployeeId SERIAL PRIMARY KEY,
  Name VARCHAR(255),
  Email VARCHAR(255),
  PhoneNum VARCHAR(20),
  Supervisor INT
);
SELECT * FROM "Employee";

-- Create Customer Table
CREATE TABLE "Customer" (
  CustomerId SERIAL PRIMARY KEY,
  Name VARCHAR(255),
  Email VARCHAR(255),
  PhoneNum VARCHAR(20),
  UserID INT,
  CONSTRAINT fk_customer_user FOREIGN KEY (UserID) REFERENCES "User"(UserID)
);
SELECT * FROM "Customer";

-- Create Location Table
CREATE TABLE "Location" (
  LocationID SERIAL PRIMARY KEY,
  City VARCHAR(255),
  Country VARCHAR(255),
  Continent VARCHAR(255),
  Zip VARCHAR(20),
  State VARCHAR(255)
);
SELECT * FROM "Location";

-- Create Property Table
CREATE TABLE "Property" (
  PropertyID SERIAL PRIMARY KEY,
  Name VARCHAR(255),
  Type VARCHAR(50),
  PropertyDesc VARCHAR(1000),
  Price DECIMAL(10, 2),
  City VARCHAR(255),
  Zip VARCHAR(20),
  State VARCHAR(255),
  CountryID INT,
  CONSTRAINT fk_property_location FOREIGN KEY (CountryID) REFERENCES "Location"(LocationID)
);
SELECT * FROM "Property";

-- Create Booking Table
CREATE TABLE "Booking" (
  BookingID SERIAL PRIMARY KEY,
  CheckInDate DATE,
  CheckOutDate DATE,
  GuestCount INT,
  BookingType VARCHAR(50),
  Supervisor INT,
  CustomerId INT,
  PropertyID INT,
  CONSTRAINT fk_booking_customer FOREIGN KEY (CustomerId) REFERENCES "Customer"(CustomerId),
  CONSTRAINT fk_booking_property FOREIGN KEY (PropertyID) REFERENCES "Property"(PropertyID)
);
SELECT * FROM "Booking";

-- Create Review Table
CREATE TABLE "Review" (
  ReviewID SERIAL PRIMARY KEY,
  Rating INT,
  Comment VARCHAR(1000),
  BookingID INT,
  CONSTRAINT fk_review_booking FOREIGN KEY (BookingID) REFERENCES "Booking"(BookingID)
);
SELECT * FROM "Review";

-- Create Amenity Table
CREATE TABLE "Amenity" (
  AmenityID SERIAL PRIMARY KEY,
  Name VARCHAR(255),
  Details VARCHAR(1000),
  PropertyId INT,
  CONSTRAINT fk_amenity_property FOREIGN KEY (PropertyId) REFERENCES "Property"(PropertyID)
);
SELECT * FROM "Amenity";

-- Create Category Table
CREATE TABLE "Category" (
  CategoryID SERIAL PRIMARY KEY,
  Name VARCHAR(255),
  RoomType VARCHAR(1000),
  RoomSize VARCHAR(1000),
  RoomFeatures VARCHAR(1000),
  PropertyId INT,
  BookingId  INT,
  CONSTRAINT fk_category_property FOREIGN KEY (PropertyId) REFERENCES "Property"(PropertyID),
  CONSTRAINT fk_category_booking FOREIGN KEY (BookingId) REFERENCES "Booking"(BookingID)
);
SELECT * FROM "Category";

-- Create Cards Table
CREATE TABLE "Cards" (
  CardID SERIAL PRIMARY KEY,
  CardName VARCHAR(255),
  CardNum VARCHAR(1000),
  CardComp VARCHAR(1000),
  CardExp VARCHAR(1000),
  CustomerId INT,
  PaymentId  INT,
  CONSTRAINT fk_cards_customer FOREIGN KEY (CustomerId) REFERENCES "Customer"(CustomerID),
  CONSTRAINT fk_cards_payment FOREIGN KEY (PaymentId) REFERENCES "Payment"(PaymentID)
);
SELECT * FROM "Cards";

-- Create Promotion Table
CREATE TABLE "Promotion" (
  PromotionID SERIAL PRIMARY KEY,
  PromotionName VARCHAR(255),
  Description VARCHAR(1000),
  DiscountPercentage DECIMAL(5, 2),
  StartDate DATE,
  EndDate DATE
);
SELECT * FROM "Promotion";

-- Create Coupon Table
CREATE TABLE "Coupon" (
  CouponID SERIAL PRIMARY KEY,
  PromotionID INT,
  CouponCode VARCHAR(50),
  DiscountAmount DECIMAL(10, 2),
  ExpiryDate DATE,
  CONSTRAINT fk_coupon_promotion FOREIGN KEY (PromotionID) REFERENCES "Promotion"(PromotionID)
);
SELECT * FROM "Coupon";

-- Create PaymentMethod Table
CREATE TABLE "PaymentMethod" (
  MethodID SERIAL PRIMARY KEY,
  CustomerId INT,
  MethodName VARCHAR(50),
  AccountNumber VARCHAR(255),
  Description VARCHAR(255),
  CONSTRAINT fk_payment_method_customer FOREIGN KEY (CustomerId) REFERENCES "Customer"(CustomerID)
);
SELECT * FROM "PaymentMethod";

-- Create Payment Table
CREATE TABLE "Payment" (
  PaymentID SERIAL PRIMARY KEY,
  Amount DECIMAL(10, 2),
  PaymentDate DATE,
  BookingID INT,
  CustomerId INT,
  MethodID INT,
  CONSTRAINT fk_payment_booking FOREIGN KEY (BookingID) REFERENCES "Booking"(BookingID),
  CONSTRAINT fk_payment_customer FOREIGN KEY (CustomerId) REFERENCES "Customer"(CustomerID),
  CONSTRAINT fk_payment_method FOREIGN KEY (MethodID) REFERENCES "PaymentMethod"(MethodID)
);

-- Create BookingHistory Table
CREATE TABLE "BookingHistory" (
  BookingHistoryId SERIAL PRIMARY KEY,
  BookingID INT,
  CustomerId INT,
  PropertyID INT,
  CheckInDate DATE,
  CheckOutDate DATE,
  TotalCost DECIMAL(10, 2),
  CONSTRAINT fk_booking_history_booking FOREIGN KEY (BookingID) REFERENCES "Booking"(BookingID),
  CONSTRAINT fk_booking_history_customer FOREIGN KEY (CustomerId) REFERENCES "Customer"(CustomerID),
  CONSTRAINT fk_booking_history_property FOREIGN KEY (PropertyID) REFERENCES "Property"(PropertyID)
);
SELECT * FROM "BookingHistory";

-- Create Wishlist Table
CREATE TABLE "Wishlist" (
  WishListID SERIAL PRIMARY KEY,
  CustomerID INT,
  PropertyID INT,
  Details VARCHAR,
  Timestamp TIMESTAMP,
  CONSTRAINT fk_wishlist_customer FOREIGN KEY (CustomerID) REFERENCES "Customer"(CustomerID),
  CONSTRAINT fk_wishlist_property FOREIGN KEY (PropertyID) REFERENCES "Property"(PropertyID)
);
SELECT * FROM "Wishlist";

-- Create Discount Table
CREATE TABLE "Discount" (
  DiscountId SERIAL PRIMARY KEY,
  Discountpercent DECIMAL(5, 2),
  Valid BOOLEAN
);

-- Create CouponRedemption Table
CREATE TABLE "CouponRedemption" (
  CouponId INT,
  CustomerId INT,
  BookingId INT,
  RedemptionDate DATE,
  CONSTRAINT fk_coupon_redemption_coupon FOREIGN KEY (CouponId) REFERENCES "Coupon"(CouponId),
  CONSTRAINT fk_coupon_redemption_customer FOREIGN KEY (CustomerId) REFERENCES "Customer"(CustomerID),
  CONSTRAINT fk_coupon_redemption_booking FOREIGN KEY (BookingId) REFERENCES "Booking"(BookingID)
);

-- Create BookingPromotion Table
CREATE TABLE "BookingPromotion" (
  PromotionId INT,
  BookingId INT,
  CONSTRAINT fk_booking_promotion_promotion FOREIGN KEY (PromotionId) REFERENCES "Promotion"(PromotionID),
  CONSTRAINT fk_booking_promotion_booking FOREIGN KEY (BookingId) REFERENCES "Booking"(BookingID)
);
SELECT * FROM "BookingPromotion";









 