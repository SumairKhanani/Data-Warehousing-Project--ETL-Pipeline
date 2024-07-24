from flask import Flask, render_template, jsonify
from dash import Dash, dcc, html
from dash.dependencies import Input, Output
import pandas as pd
import sqlite3
import time
from threading import Thread
import calendar
import plotly.graph_objs as go

server = Flask(__name__)

# Initialize the Dash app within the Flask server
app = Dash(__name__, server=server, url_base_pathname='/')

# Define the layout of the Dash app
app.layout = html.Div(children=[
    html.H1(children='Airbnb Booking and Revenue Dashboard'),
    
    dcc.Graph(id='revenue-by-city'),
    dcc.Graph(id='monthly-booking-trends'),
    dcc.Graph(id='property-booking-pie-chart'),
    dcc.Graph(id='discount-heatmap'),
    
    dcc.Interval(
        id='interval-component',
        interval=60*1000,  # in milliseconds
        n_intervals=0
    )
])

# Placeholder function for data retrieval
def get_data(query):
    # Simulate data retrieval from a database
    # Establish connection to a SQLite database
    conn = sqlite3.connect('NewDATABSE.db')
    # Execute the query and fetch data into a pandas DataFrame
    data = pd.read_sql_query(query, conn)
    # Close the database connection
    conn.close()
    return data

##Define the callbacks for updating the graphs
@app.callback(Output('revenue-by-city', 'figure'),
              [Input('interval-component', 'n_intervals')])
def update_revenue_by_city(n):
    try:
        query = "SELECT l.City, SUM(f.Amount) AS TotalRevenue FROM FactTable f JOIN LocationDimension l ON f.LocationID = l.LocationID GROUP BY l.City;"
        df = get_data(query)
        figure = {
            'data': [{'x': df['City'], 'y': df['TotalRevenue'], 'type': 'bar', 'name': 'Revenue by City'}],
            'layout': {'title': 'Revenue by City'}
        }
        return figure
    except Exception as e:
        print("Error updating revenue-by-city.figure:", str(e))


@app.callback(Output('monthly-booking-trends', 'figure'),
              [Input('interval-component', 'n_intervals')])
def update_monthly_booking_trends(n):
    try:
        # Example of query and data retrieval
        query = "SELECT t.Year, t.Month, COUNT(f.BookingID) AS Booking_Count FROM FactTable f INNER JOIN DateDimension t ON f.DateID = t.DateID GROUP BY t.Year, t.Month ORDER BY t.Year, t.Month;"
        df = get_data(query)
        # Convert numeric month values to month names
        df['Month'] = df['Month'].apply(lambda x: calendar.month_name[x])
        figure = {
            'data': [{'x': df['Month'], 'y': df['Booking_Count'], 'type': 'line', 'name': 'Monthly Booking Trends'}],
            'layout': {'title': 'Monthly Booking Trends'}
        }
        return figure
    except Exception as e:
        print("Error updating monthly-booking-trends.figure:", str(e))

@app.callback(Output('discount-heatmap', 'figure'),
              [Input('interval-component', 'n_intervals')])
def update_discount_heatmap(n):
    try:
        # Example of query and data retrieval
        query = "SELECT t.Year, t.Month, SUM(f.DiscountAmount) AS Total_Discount_Available FROM FactTable f INNER JOIN DateDimension t ON f.DateID = t.DateID GROUP BY t.Year, t.Month ORDER BY t.Year, t.Month;"
        df = get_data(query)
        # Create a pivot table to prepare data for heatmap
        pivot_df = df.pivot(index='Month', columns='Year', values='Total_Discount_Available')
        # Reorder columns to ensure proper sorting by year
        pivot_df = pivot_df[sorted(pivot_df.columns)]
        # Create heatmap
        heatmap = go.Heatmap(z=pivot_df.values,
                             x=pivot_df.columns,
                             y=pivot_df.index,
                             colorscale='Viridis')
        layout = {'title': 'Total Discount Amount Available (Heatmap)',
                  'xaxis': {'title': 'Year'},
                  'yaxis': {'title': 'Month'}}
        figure = {'data': [heatmap], 'layout': layout}
        return figure
    except Exception as e:
        print("Error updating discount heatmap:", str(e))

@app.callback(Output('property-booking-pie-chart', 'figure'),
              [Input('interval-component', 'n_intervals')])
def update_property_booking_pie_chart(n):
    try:
        # Example of query and data retrieval
        query = """
            SELECT 
                p.PropertyType,
                COUNT(*) AS BookingCount
            FROM 
                FactTable f 
            INNER JOIN 
                PropertyDimension p ON f.PropertyID = p.PropertyID
            GROUP BY  
                p.PropertyType
            ORDER BY 
                BookingCount DESC;
        """
        df = get_data(query)
        # Create a pie chart
        pie_chart = go.Figure(data=[go.Pie(labels=df['PropertyType'], values=df['BookingCount'])])
        pie_chart.update_layout(title='Property Booking Count Pie Chart')
        return pie_chart
    except Exception as e:
        print("Error updating property-booking-pie-chart:", str(e))



# Simulated data update function
def master_function():
    while True:
        try:
            # Simulate data update
            print("Data updated at:", time.ctime())
            
            # Sleep for a specified time interval (e.g., 60 seconds)
            time.sleep(60)
        except KeyboardInterrupt:
            break

if __name__ == '__main__':
    # Start the data update thread
    thread = Thread(target=master_function)
    thread.start()
    
    # Run the Flask server  
    server.run(debug=True, port=5000)
