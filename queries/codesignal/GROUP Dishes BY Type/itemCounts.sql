SELECT DISTINCT(item_name), item_type, COUNT(item_name) AS item_count
FROM availableItems
GROUP BY item_type, item_name
ORDER BY item_type ASC, item_name ASC;