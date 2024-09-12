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
      browser
    FROM
      unique_data) PIVOT(COUNT(*) FOR browser IN ("Chrome", "Android Webview", "Edge", "Safari", "<Other>", "Firefox"))
  WHERE
    event_name IN ("page_view",
      "view_item",
      "add_to_cart",
      "begin_checkout",
      "purchase")),


  pivoted_table_total_column AS(
  SELECT
    *,
    Chrome + `Android Webview` + Edge + Safari + `<Other>` + Firefox AS Browser_Total
  FROM
    pivoted_table)



SELECT
  event_name AS Event,
  Chrome AS Chrome_Event_Count,
  `Android Webview` AS Android_Webview_Event_Count,
  Edge AS Edge_Event_Count,
  Safari AS Safari_Event_Count,
  `<Other>` AS Other_Event_Count,
  Firefox AS Firefox_Event_Count,
  ROUND(Browser_Total*100/(MAX(Browser_Total) OVER ()),2) AS Total_Percentage,
  ROUND(Chrome*100/(MAX(Chrome) OVER ()),2) AS Chrome_Percentage,
  ROUND(`Android Webview`*100/(MAX(`Android Webview`) OVER ()),2) AS Android_Webview_Percentage,
  ROUND(Edge*100/(MAX(Edge) OVER ()),2) AS Edge_Percentage,
  ROUND(Safari*100/(MAX(Safari) OVER ()),2) AS Safari_Percentage,
  ROUND(`<Other>`*100/(MAX(`<Other>`) OVER ()),2) AS Other_Percentage,
  ROUND(Firefox*100/(MAX(Firefox) OVER ()),2) AS Firefox_Percentage,
FROM
  pivoted_table_total_column
ORDER BY
  Browser_Total DESC