import pandas as pd
import psycopg2

# List of Excel file names
excel_files = ['User.xlsx', 'Amenity.xlsx', 'BookingHistory.xlsx', 'BookingPromotion.xlsx', 'Booking.xlsx',
               'Cards.xlsx', 'Category.xlsx', 'CouponRedemption.xlsx', 'Coupon.xlsx', 'Customer.xlsx',
               'Discount.xlsx', 'Employee.xlsx', 'Location.xlsx', 'Owner.xlsx', 'PaymentMethod.xlsx',
               'Payment.xlsx', 'Promotion.xlsx', 'Property.xlsx', 'Review.xlsx', 'Wishlist.xlsx']

# Initialize an empty dictionary to store DataFrames
dfs = {}

# Iterate over the list of Excel files
for file_name in excel_files:
    # Load Excel file into a pandas DataFrame
    df = pd.read_excel(file_name)
    # Store DataFrame in the dictionary with file name as key
    dfs[file_name] = df

    # Connect to your PostgreSQL database
conn = psycopg2.connect(
    dbname="DWHHOTELMANGAMENT",   # Update with your database name
    user="postgres",          # Update with your username
    password="postgres",      # Update with your password
    host="localhost",              # Update with your host (e.g., localhost)
    port="5432"               # Update with your port (e.g., 5432)
)

# Create a cursor object
cur = conn.cursor()
