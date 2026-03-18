
SELECT z.borough, 
       AVG(t.fare_amount) AS avg_fare, 
       COUNT(*) AS trip_count
FROM dbo.taxi_trips t
JOIN dbo.taxi_zones z ON t.pickup_zone_id = z.zone_id
GROUP BY z.borough
ORDER BY avg_fare DESC;