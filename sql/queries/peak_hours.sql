
SELECT DATEPART(HOUR, pickup_datetime) AS pickup_hour,
       COUNT(*) AS trip_count,
       AVG(trip_distance) AS avg_distance
FROM dbo.taxi_trips
GROUP BY DATEPART(HOUR, pickup_datetime)
ORDER BY trip_count DESC;