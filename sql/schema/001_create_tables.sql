
-- NYC Taxi Schema for Azure Data Platform
-- Created: 2026-03-17

-- Taxi Zone lookup table (borough/zone reference data)
CREATE TABLE dbo.taxi_zones (
    zone_id        INT PRIMARY KEY,
    borough        NVARCHAR(50)  NOT NULL,
    zone_name      NVARCHAR(100) NOT NULL,
    service_zone   NVARCHAR(50)  NOT NULL
);

-- Taxi trip fact table
CREATE TABLE dbo.taxi_trips (
    trip_id             BIGINT IDENTITY(1,1) PRIMARY KEY,
    vendor_id           TINYINT        NOT NULL,
    pickup_datetime     DATETIME2(0)   NOT NULL,
    dropoff_datetime    DATETIME2(0)   NOT NULL,
    passenger_count     TINYINT,
    trip_distance       DECIMAL(8,2)   NOT NULL,
    pickup_zone_id      INT            NOT NULL REFERENCES dbo.taxi_zones(zone_id),
    dropoff_zone_id     INT            NOT NULL REFERENCES dbo.taxi_zones(zone_id),
    fare_amount         DECIMAL(8,2)   NOT NULL,
    tip_amount          DECIMAL(8,2)   NOT NULL DEFAULT 0,
    total_amount        DECIMAL(8,2)   NOT NULL,
    payment_type        TINYINT        NOT NULL
);

-- Indexes for common query patterns
CREATE INDEX IX_taxi_trips_pickup ON dbo.taxi_trips(pickup_datetime);
CREATE INDEX IX_taxi_trips_zones  ON dbo.taxi_trips(pickup_zone_id, dropoff_zone_id);