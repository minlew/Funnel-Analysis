WITH
  chosen_data AS(
  SELECT
    ROW_NUMBER() OVER (PARTITION BY user_pseudo_id, event_name ORDER BY event_timestamp) AS duplicate_index,
    #creates a ROW count that restarts AT 1 FOR every unique id+event combo, but will count up if there are multiple of the same event for the same id 
    event_timestamp,
    event_name,
    user_pseudo_id,
    category,
    browser,
    country
  FROM
    `turing_data_analytics.raw_events`
  ORDER BY
    user_pseudo_id,
    event_name),


  unique_data AS(
  SELECT
    *
  FROM
    chosen_data
  WHERE
    duplicate_index = 1
  ORDER BY
    user_pseudo_id,
    event_name),


  pivoted_table AS(
  SELECT
    *
  FROM (
    SELECT
      event_name,
      country
    FROM
      unique_data) PIVOT(COUNT(*) FOR country IN ("United States",
        "India",
        "Canada"))
  WHERE
    event_name IN ("page_view",
      "view_item",
      "add_to_cart",
      "begin_checkout",
      "purchase")),


  pivoted_table_total_column AS(
  SELECT
    *,
    `United States`+India+Canada AS Country_Total
  FROM
    pivoted_table)



SELECT
  event_name AS Event,
  `United States` AS US_Event_Count,
  India AS India_Event_Count,
  Canada AS Canada_Event_Count,
  ROUND(Country_Total*100/(MAX(Country_Total) OVER ()),2) AS Total_Percentage,
  ROUND(`United States`*100/(MAX(`United States`) OVER ()),2) AS US_Percentage,
  ROUND(India*100/(MAX(India) OVER ()),2) AS India_Percentage,
  ROUND(Canada*100/(MAX(Canada) OVER ()),2) AS Canada_Percentage
FROM
  pivoted_table_total_column
ORDER BY
  Country_Total DESC