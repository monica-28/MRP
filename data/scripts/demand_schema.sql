CREATE VIEW IF NOT EXISTS v_weekly_orders (
xitem_id,
pending_qty,
week_start
)
AS (
SELECT xitem_id AS item, 
sum(xquantity) AS pending_qty, 
date(xscheduled_delivery_date, 'weekday 0', '-6 days') week_start
FROM sales_order_lines
GROUP BY xitem_id, week_start
)

