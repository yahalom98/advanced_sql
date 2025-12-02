# Ride-Sharing App Case Study

## Business Context

You're analyzing data for "RideEasy", a ride-sharing platform operating in multiple cities. The company needs insights on driver performance, trip patterns, pricing optimization, and user satisfaction.

## Key Business Goals

1. Optimize driver allocation and earnings
2. Improve rider experience and retention
3. Identify peak demand patterns
4. Reduce cancellations and wait times
5. Maximize revenue per trip

## Required Schema

### Core Tables

**drivers**
- driver_id (PK)
- name, email, phone
- city_id (FK)
- vehicle_type
- registration_date
- status (active, inactive, suspended)
- rating

**riders**
- rider_id (PK)
- name, email, phone
- city_id (FK)
- registration_date
- total_trips
- rating

**cities**
- city_id (PK)
- city_name, state, country
- timezone

**zones**
- zone_id (PK)
- city_id (FK)
- zone_name
- latitude, longitude

**vehicles**
- vehicle_id (PK)
- driver_id (FK)
- make, model, year
- license_plate
- capacity

**trips**
- trip_id (PK)
- driver_id (FK)
- rider_id (FK)
- pickup_zone_id (FK)
- dropoff_zone_id (FK)
- trip_date, trip_time
- distance_km
- duration_minutes
- base_fare
- distance_fare
- time_fare
- surge_multiplier
- total_fare
- tip_amount
- status (completed, cancelled, in_progress)
- cancellation_reason

**ratings**
- rating_id (PK)
- trip_id (FK)
- rated_by (driver/rider)
- rating (1-5)
- comment
- rating_date

**payments**
- payment_id (PK)
- trip_id (FK)
- payment_method
- payment_date
- amount
- status (completed, pending, failed)

**promotions**
- promotion_id (PK)
- promotion_code
- discount_type (percentage, fixed)
- discount_value
- start_date, end_date
- usage_limit

**promotion_usage**
- promotion_id (FK)
- trip_id (FK)
- rider_id (FK)
- usage_date

## Business Questions

1. **Average trip duration by city**
   - Compare cities
   - Identify traffic patterns

2. **Top drivers by ratings and earnings**
   - Combine rating and revenue
   - Identify star drivers

3. **Peak hours and days**
   - Demand by hour of day
   - Demand by day of week
   - Identify surge pricing opportunities

4. **Driver utilization rate**
   - Trips per hour
   - Active hours per day
   - Efficiency metrics

5. **Average fare by distance category**
   - Short (<5km), Medium (5-15km), Long (>15km)
   - Pricing analysis

6. **High-demand zones**
   - Pickup and dropoff hotspots
   - Zone-to-zone patterns

7. **Driver churn risk**
   - Low activity drivers
   - Declining ratings
   - Revenue trends

8. **Cancellation analysis**
   - Cancellation rate by driver
   - Cancellation rate by rider
   - Common reasons

9. **Revenue per driver**
   - Monthly earnings
   - By city and vehicle type
   - Trends over time

10. **Surge pricing patterns**
    - When surge occurs most
    - Impact on demand
    - Revenue impact

11. **Rider retention**
    - Repeat rider rate
    - Time between trips
    - Loyalty metrics

12. **Most profitable routes**
    - Zone pairs with highest revenue
    - Distance vs fare analysis

13. **Average wait time by zone**
    - Time from request to pickup
    - Driver availability

14. **Rating completion rate**
    - Percentage of trips with ratings
    - Rating distribution

15. **Driver earnings distribution**
    - Percentiles
    - Income inequality
    - Opportunities for improvement

## Data Requirements

- **Minimum 500 drivers across 5+ cities**
- **Minimum 2,000 riders**
- **Minimum 10,000 trips**
- **6 months of historical data**
- **Multiple zones per city**
- **Realistic surge pricing events**
- **Cancellation rate ~10-15%**

## Deliverables

1. Complete schema (DDL)
2. Data population script
3. SQL queries for all 15 questions
4. Dashboard summary
5. Presentation with key insights

## Success Criteria

- Schema supports all business questions
- Queries handle time-based analysis
- Geographic analysis is accurate
- Performance metrics are meaningful

Good luck! 🚗

