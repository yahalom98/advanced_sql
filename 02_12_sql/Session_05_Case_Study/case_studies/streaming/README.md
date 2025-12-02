# Streaming Platform Case Study

## Business Context

You're working for "StreamMax", a video streaming service competing with Netflix and Hulu. Analyze content performance, user engagement, subscription trends, and content recommendations to drive growth and reduce churn.

## Key Business Goals

1. Understand content performance and popularity
2. Reduce churn and increase retention
3. Optimize content library
4. Improve user engagement
5. Maximize subscription revenue

## Required Schema

### Core Tables

**users**
- user_id (PK)
- email, name
- registration_date
- country
- acquisition_channel

**subscriptions**
- subscription_id (PK)
- user_id (FK)
- plan_id (FK)
- start_date
- end_date (NULL if active)
- status (active, cancelled, expired)
- cancellation_reason

**plans**
- plan_id (PK)
- plan_name (Basic, Standard, Premium)
- monthly_price
- features (HD, 4K, simultaneous_streams)

**content**
- content_id (PK)
- title, description
- content_type (movie, tv_show)
- release_date
- duration_minutes
- rating (PG, PG-13, R, etc.)
- is_original (boolean)

**genres**
- genre_id (PK)
- genre_name

**content_genres**
- content_id (FK)
- genre_id (FK)

**actors**
- actor_id (PK)
- actor_name

**content_actors**
- content_id (FK)
- actor_id (FK)

**directors**
- director_id (PK)
- director_name

**content_directors**
- content_id (FK)
- director_id (FK)

**watch_history**
- watch_id (PK)
- user_id (FK)
- content_id (FK)
- watch_date
- watch_duration_minutes
- completion_percentage
- device_type (mobile, tablet, tv, desktop)

**ratings**
- rating_id (PK)
- user_id (FK)
- content_id (FK)
- rating (1-5)
- review_text
- rating_date

**sessions**
- session_id (PK)
- user_id (FK)
- start_time, end_time
- device_type
- content_watched (array or JSON)

## Business Questions

1. **Most popular content by genre**
   - Watch count and completion rates
   - Ratings by genre

2. **Average watch time per user**
   - Total minutes watched
   - Sessions per user
   - Engagement score

3. **Content with highest completion rates**
   - Percentage of users who finish
   - Identify binge-worthy content

4. **Churn rate by subscription plan**
   - Cancellation rates
   - Plan comparison
   - Retention by plan

5. **Top actors and directors**
   - Appearances in highly-rated content
   - Content performance by creator

6. **User engagement score**
   - Sessions per week
   - Watch time trends
   - Active vs inactive users

7. **Revenue by subscription tier**
   - Monthly recurring revenue
   - Plan distribution
   - Upsell opportunities

8. **Churn risk identification**
   - Users with declining engagement
   - No activity in 30+ days
   - At-risk segments

9. **Content driving new subscriptions**
   - First content watched by new users
   - Acquisition content analysis

10. **Average session duration by device**
    - Device preferences
    - Engagement by platform

11. **Genre retention analysis**
    - Which genres keep users engaged
    - Genre preferences by user segment

12. **Content discovery patterns**
    - How users find content
    - Search vs recommendations
    - Browse patterns

13. **Peak viewing hours**
    - Time of day analysis
    - Day of week patterns
    - Device usage by time

14. **Lifetime value by acquisition channel**
    - CLV by marketing channel
    - Channel effectiveness

15. **Binge-watching patterns**
    - Multiple episodes in one session
    - Series completion rates
    - Binge indicators

## Data Requirements

- **Minimum 5,000 users**
- **Minimum 1,000 content items (movies + TV shows)**
- **Minimum 50,000 watch sessions**
- **12 months of historical data**
- **Multiple subscription plans**
- **Realistic churn rate (5-10% monthly)**
- **Diverse content library (10+ genres)**

## Deliverables

1. Complete schema (DDL)
2. Data population script
3. SQL queries for all 15 questions
4. Dashboard summary
5. Presentation with key insights

## Success Criteria

- Schema handles complex content relationships
- Queries support time-series analysis
- Engagement metrics are meaningful
- Churn analysis is actionable

Good luck! 🎬

