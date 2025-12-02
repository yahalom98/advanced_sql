# Fitness App Case Study

## Business Context

You're analyzing "FitTrack", a fitness tracking app with workout plans, social features, and goal tracking. The company needs insights on user engagement, workout patterns, goal achievement, and social interactions.

## Key Business Goals

1. Increase user engagement and retention
2. Improve workout program effectiveness
3. Understand social feature usage
4. Optimize goal-setting features
5. Identify power users and advocates

## Required Schema

### Core Tables

**users**
- user_id (PK)
- name, email
- registration_date
- age, gender
- fitness_level (beginner, intermediate, advanced)
- goals (weight_loss, muscle_gain, endurance, general)

**workouts**
- workout_id (PK)
- user_id (FK)
- workout_date
- workout_type (cardio, strength, yoga, etc.)
- duration_minutes
- calories_burned
- program_id (FK, nullable)

**exercises**
- exercise_id (PK)
- exercise_name
- exercise_type
- muscle_groups
- difficulty_level

**workout_exercises**
- workout_id (FK)
- exercise_id (FK)
- sets, reps
- weight (for strength)
- duration (for cardio)

**programs**
- program_id (PK)
- program_name
- description
- duration_weeks
- difficulty_level
- coach_id (FK)

**coaches**
- coach_id (PK)
- name, bio
- specialization
- rating

**goals**
- goal_id (PK)
- user_id (FK)
- goal_type (weight, distance, strength, etc.)
- target_value
- start_date, target_date
- current_value
- status (active, completed, abandoned)

**achievements**
- achievement_id (PK)
- achievement_name
- description
- category (streak, milestone, social)

**user_achievements**
- user_id (FK)
- achievement_id (FK)
- unlocked_date

**streaks**
- streak_id (PK)
- user_id (FK)
- streak_type (workout, login)
- current_days
- longest_days
- last_activity_date

**friends**
- friendship_id (PK)
- user_id_1 (FK)
- user_id_2 (FK)
- status (pending, accepted)
- created_date

**challenges**
- challenge_id (PK)
- challenge_name
- description
- start_date, end_date
- challenge_type (workout_count, distance, etc.)
- target_value

**challenge_participants**
- challenge_id (FK)
- user_id (FK)
- current_progress
- joined_date

**nutrition_logs**
- log_id (PK)
- user_id (FK)
- log_date
- calories_consumed
- protein_g, carbs_g, fat_g

## Business Questions

1. **Average workout frequency per user**
   - Workouts per week
   - By user segment
   - Trends over time

2. **Most popular exercises**
   - Exercise frequency
   - By workout type
   - User preferences

3. **Goal completion rates**
   - Success rate by goal type
   - Average time to completion
   - Abandonment analysis

4. **Longest workout streaks**
   - Top users by streak
   - Streak distribution
   - Streak impact on retention

5. **Engagement rate by cohort**
   - Registration month cohorts
   - Activity retention
   - Cohort comparison

6. **Workout program completion rates**
   - Programs with highest completion
   - Drop-off points
   - Program effectiveness

7. **Average workout duration by type**
   - Cardio vs strength vs yoga
   - Trends over time
   - User preferences

8. **Churn risk identification**
   - Inactive 30+ days
   - Declining engagement
   - At-risk users

9. **Social engagement metrics**
   - Friends per user
   - Challenge participation
   - Social vs solo users

10. **Coach performance**
    - Active users per coach
    - Program completion rates
    - Coach ratings

11. **User progression over time**
    - Improvement metrics
    - Goal achievement trends
    - Fitness level changes

12. **Seasonal workout trends**
    - Workout patterns by month
    - New Year resolutions impact
    - Summer vs winter activity

13. **Power users identification**
    - Top 10% by activity
    - Characteristics
    - Retention rates

14. **Achievement unlock rates**
    - Most common achievements
    - Rare achievements
    - Achievement impact on engagement

15. **Workout patterns by time of day**
    - Morning vs evening workouts
    - Peak hours
    - Consistency patterns

## Data Requirements

- **Minimum 2,000 users**
- **Minimum 20,000 workouts**
- **Minimum 100 exercises**
- **Minimum 10 workout programs**
- **12 months of historical data**
- **Realistic goal completion rates (30-50%)**
- **Social features usage (40-60% of users)**

## Deliverables

1. Complete schema (DDL)
2. Data population script
3. SQL queries for all 15 questions
4. Dashboard summary
5. Presentation with key insights

## Success Criteria

- Schema supports social features
- Queries handle time-series analysis
- Engagement metrics are meaningful
- Goal tracking is accurate

Good luck! 💪

