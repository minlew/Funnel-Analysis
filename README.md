# E-commerce Analytics SQL Project

## Project Description
This project contains a series of SQL queries designed to analyze e-commerce data. The analysis focuses on event tracking across different dimensions such as country, device category, and browser type.

## Queries
The project includes three main SQL queries:
* Query1.sql: Analyzes events by country (United States, India, Canada)
* Query2.sql: Analyzes events by device category (desktop, mobile, tablet)
* Query3.sql: Analyzes events by browser type (Chrome, Android Webview, Edge, Safari, Firefox, and Others)

Each query follows a similar structure:
* Deduplicates data to ensure unique user-event combinations
* Pivots the data to create a cross-tabulation of events and the dimension being analyzed
* Calculates total counts and percentages for each event type

## Events Analyzed
The queries focus on the following e-commerce events:
* page_view
* view_item
* add_to_cart
* begin_checkout
* purchase

## Output
Each query produces a result set with the following information:
* Event counts for each category (country, device, or browser)
* Total percentage of each event type
* Percentage of each event type within each category

The results are ordered by the total count in descending order, allowing for easy identification of the most common events and their distribution across different categories.

## Requirements
* SQL environment to run the queries.
* PowerPoint to view analysis of results.
* Dataset stored in Google BigQuery (based on the SQL references).

## Additional Resources
This project also includes a PowerPoint presentation that visualizes the analysis results. Refer to this presentation for graphical representations and further insights derived from the SQL queries.
