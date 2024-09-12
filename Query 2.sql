WITH
  chosen_data AS(
  SELECT
    ROW_NUMBER() OVER (PARTITION BY user_pseudo_id, event_name ORDER BY event_timestamp) AS duplicate_index,
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
      category
    FROM
      unique_data) PIVOT(COUNT(*) FOR category IN ("desktop",
        "mobile",
        "tablet"))
  WHERE
    event_name IN ("page_view",
      "view_item",
      "add_to_cart",
      "begin_checkout",
      "purchase")),


  pivoted_table_total_column AS(
  SELECT
    *,
    desktop+mobile+tablet AS Device_Total
  FROM
    pivoted_table)



SELECT
  event_name AS Event,
  desktop AS Desktop_Event_Count,
  mobile AS Mobile_Event_Count,
  tablet AS Tablet_Event_Count,
  ROUND(Device_Total*100/(MAX(Device_Total) OVER ()),2) AS Total_Percentage,
  ROUND(desktop*100/(MAX(desktop) OVER ()),2) AS Desktop_Percentage,
  ROUND(mobile*100/(MAX(mobile) OVER ()),2) AS Mobile_Percentage,
  ROUND(tablet*100/(MAX(tablet) OVER ()),2) AS Tablet_Percentage
FROM
  pivoted_table_total_column
ORDER BY
  Device_Total DESC