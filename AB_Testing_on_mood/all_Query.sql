-- Returns first 100 rows from dsv1069.final_assignments

--DIRECTIONS: Modify this query so that it counts 
--the number of rows in the table dsv1069.users
SELECT 
   *
   FROM dsv1069.final_assignments_qa




--Reformat the final_assignments_qa to look like the final_assignments table, filling in any missing values with a placeholder of the appropriate data type.

SELECT item_id,
       test_a AS test_assignment,
       'test_a' AS test_number,
       CAST('2020-01-01 00:00:00' AS timestamp) AS dummy_test_start_date
FROM dsv1069.final_assignments_qa
UNION ALL
SELECT item_id,
       test_b AS test_assignment,
       'test_b' AS test_number,
       CAST('2020-01-01 00:00:00' AS timestamp) AS dummy_test_start_date
FROM dsv1069.final_assignments_qa
UNION ALL
SELECT item_id,
       test_c AS test_assignment,
       'test_c' AS test_number,
       CAST('2020-01-01 00:00:00' AS timestamp) AS dummy_test_start_date
FROM dsv1069.final_assignments_qa
UNION ALL
SELECT item_id,
       test_d AS test_assignment,
       'test_d' AS test_number,
       CAST('2020-01-01 00:00:00' AS timestamp) AS dummy_test_start_date
FROM dsv1069.final_assignments_qa
UNION ALL
SELECT item_id,
       test_e AS test_assignment,
       'test_e' AS test_number,
       CAST('2020-01-01 00:00:00' AS timestamp) AS dummy_test_start_date
FROM dsv1069.final_assignments_qa
UNION ALL
SELECT item_id,
       test_f AS test_assignment,
       'test_f' AS test_number,
       CAST('2020-01-01 00:00:00' AS timestamp) AS dummy_test_start_date
FROM dsv1069.final_assignments_qa





-- Use this table to
-- compute order_binary for the 30 day window after the test_start_date
-- for the test named item_test_2

SELECT order_binary.test_assignment,
       COUNT(DISTINCT order_binary.item_id) AS num_orders,
       SUM(order_binary.orders_bin_30d) AS sum_orders_bin_30d
FROM 
  (SELECT assignments.item_id,
          assignments.test_assignment,
          MAX(CASE
                  WHEN (DATE(orders.created_at)-DATE(assignments.test_start_date)) BETWEEN 1 AND 30 THEN 1
                  ELSE 0
              END) AS orders_bin_30d
  FROM dsv1069.final_assignments AS assignments
  LEFT JOIN dsv1069.orders AS orders
    ON assignments.item_id=orders.item_id 
  WHERE assignments.test_number='item_test_2'
  GROUP BY assignments.item_id,
           assignments.test_assignment) AS order_binary
  GROUP BY order_binary.test_assignment





-- Use this table to
-- compute view_binary for the 30 day window after the test_start_date
-- for the test named item_test_2

SELECT item_test_2.item_id,
       item_test_2.test_assignment,
       item_test_2.test_number,
       MAX(CASE
               WHEN (view_date > test_start_date
                     AND DATE_PART('day', view_date - test_start_date) <= 30) THEN 1
               ELSE 0
           END) AS view_binary
FROM
  (SELECT final_assignments.*,
          DATE(events.event_time) AS view_date
   FROM dsv1069.final_assignments AS final_assignments
   LEFT JOIN
       (SELECT event_time,
               CASE
                   WHEN parameter_name = 'item_id' THEN CAST(parameter_value AS NUMERIC)
                   ELSE NULL
               END AS item_id
          FROM dsv1069.events 
          WHERE event_name = 'view_item') AS events
         ON final_assignments.item_id = events.item_id 
       WHERE test_number = 'item_test_2') AS item_test_2
GROUP BY item_test_2.item_id,
         item_test_2.test_assignment,
         item_test_2.test_number
LIMIT 100;





-- Use the https://thumbtack.github.io/abba/demo/abba.html
-- to compute the lifts in metrics and the p-values for the binary
-- metrics (30 day order binary and 30 day view binary) using a
-- interval 95% confidence.
SELECT test_assignment,
       test_number,
       COUNT(DISTINCT item) AS number_of_items,
       SUM(view_binary_30d) AS view_binary_30d
FROM 
  (SELECT final_assignments.item_id AS item,
          test_assignment,
          test_number,
          test_start_date,
          MAX((CASE
                   WHEN date(event_time) - date(test_start_date) BETWEEN 0 AND 30 THEN 1
                   ELSE 0
               END)) AS view_binary_30d
    FROM dsv1069.final_assignments 
    LEFT JOIN dsv1069.view_item_events
         ON final_assignments.item_id = view_item_events.item_id 
    WHERE test_number = 'item_test_2'
    GROUP BY final_assignments.item_id,
             test_assignment,
             test_number,
             test_start_date) AS view_binary
GROUP BY test_assignment,
         test_number,
         test_start_date;