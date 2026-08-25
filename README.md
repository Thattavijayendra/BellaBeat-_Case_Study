# Bellabeat Wellness Analytics — Exploratory Data Analysis

## 📌 Project Overview

This project explores Fitbit user activity, sleep, heart-rate, and weight data to identify behavioral patterns and potential product opportunities for **Bellabeat**, a wellness technology company.

The analysis focuses on understanding how users interact with wellness-tracking features and translating those behavioral patterns into actionable business recommendations.

The project follows an end-to-end analytics workflow:

**Data → Cleaning → SQL EDA → Insights → Business Recommendations → Power BI Dashboard**

---

## 🎯 Business Objective

The goal of this analysis is to answer:

> **How are users engaging with their wellness data, and what opportunities can Bellabeat identify to improve user engagement and product experience?**

The analysis focuses on:

- Activity intensity and movement behavior
- Prolonged inactivity
- Sleep duration and sleep patterns
- Heart rate across activity intensity
- Weekday vs. weekend behavior
- Changes in activity engagement over time
- Adoption of different wellness-tracking features

---

## 🗂️ Dataset

The project uses Fitbit user activity data containing multiple datasets related to:

- Daily activity
- Hourly activity
- Minute-level activity
- Sleep
- Heart rate
- Weight
- User activity summaries

The datasets were cleaned and prepared before being loaded into MySQL for exploratory analysis.

> **Note:** Different datasets contain different numbers of users, so feature-level adoption varies across activity, sleep, heart rate, and weight tracking.

---

## 🛠️ Tools & Technologies

| Tool | Purpose |
|---|---|
| **Excel** | Data inspection, cleaning and preparation |
| **MySQL** | Data transformation and exploratory analysis |
| **Power BI** | Data visualization and stakeholder dashboard |
| **GitHub** | Project documentation and version control |

---

# 🔍 Exploratory Data Analysis

The EDA was structured around several business questions rather than simply exploring every available variable.

## 1. Activity Intensity

The analysis examined the distribution of active minutes across different activity intensity levels.

### Key Finding

- **84.89%** of recorded active minutes were classified as light activity.
- Only **8.97%** were very active.
- Moderate activity accounted for **6.14%**.

### Business Implication

Users spend most of their active time at lower intensity levels, creating an opportunity for Bellabeat to encourage gradual increases in activity.

---

## 2. Prolonged Inactivity

Continuous periods of zero-step activity were identified using SQL session/island-and-gap logic.

### Key Finding

- **5,726** inactivity episodes lasted 30–59 minutes.
- **1,654** lasted 60–90 minutes.
- **3,229** lasted 90+ minutes.

### Business Implication

Long periods of inactivity create an opportunity for personalized movement reminders that encourage users to take short movement breaks.

---

## 3. Weekday vs. Weekend Activity

Activity levels were compared between weekdays and weekends.

### Key Finding

Average daily steps were:

- **Weekday:** 7,452.94
- **Weekend:** 7,188.27

Weekend activity was therefore slightly lower than weekday activity.

### Business Implication

Bellabeat could use weekly activity insights and weekend-specific nudges to help users maintain consistent movement throughout the week.

---

## 4. Sleep Duration

Night-sleep sessions were classified into three duration groups:

- `<7 hours`
- `7–9 hours`
- `9+ hours`

### Key Finding

- **43.76%** of recorded night-sleep sessions were below 7 hours.
- **39.84%** were between 7–9 hours.
- **16.40%** were 9+ hours.

### Business Implication

The large proportion of shorter sleep sessions suggests an opportunity for personalized sleep guidance and consistency coaching.

---

## 5. Heart Rate vs. Activity Intensity

Average heart rate was compared across activity intensity levels.

| Activity Intensity | Average HR |
|---|---:|
| Sedentary | 68.48 BPM |
| Light | 85.98 BPM |
| Moderate | 101.91 BPM |
| Very Active | 120.17 BPM |

### Key Finding

Average heart rate increased consistently as activity intensity increased.

### Data Limitation

Heart-rate data was available for only **15 of the 35 users**, so this finding represents the subset with heart-rate data.

### Business Implication

Activity intensity and heart-rate information could support more personalized wellness feedback.

---

# 📈 Activity Engagement Over Time

Activity engagement was compared between Month 1 and Month 2 using average daily steps and average active minutes.

| Metric | Month 1 | Month 2 |
|---|---:|---:|
| Average Daily Steps | 5,861.71 | 7,226.58 |
| Average Active Minutes | 168.27 | 228.28 |

### Key Finding

Both average daily steps and average active minutes were higher in Month 2.

### Business Implication

The increase suggests an opportunity to reinforce continued activity through progressive challenges and positive feedback.

> This analysis measures **activity engagement**, rather than overall device engagement.

---

# 💡 Business Recommendations

The EDA led to the following potential product opportunities for Bellabeat:

### 🚶 1. Personalized Movement Reminders

Detect prolonged inactivity and provide context-aware reminders encouraging users to take short movement breaks.

### 🏃 2. Progressive Activity Challenges

Encourage users to gradually increase activity intensity through personalized goals, milestones, and rewards.

### 😴 3. Sleep Consistency Coaching

Use sleep behavior to provide personalized guidance around sleep duration and regular routines.

### 📊 4. Weekly Wellness Summary

Combine activity and sleep information into an easy-to-understand weekly report showing trends, progress, and areas for improvement.

---

# 📊 Power BI Dashboard

The findings were translated into a one-page stakeholder dashboard containing:

- Feature adoption KPIs
- Activity intensity distribution
- Activity engagement: Month 1 vs Month 2
- Prolonged inactivity episodes
- Weekday vs weekend activity
- Heart rate vs activity intensity
- Night-sleep duration distribution

The dashboard is designed to communicate the key findings and connect them directly to potential product opportunities.

---

# ⚠️ Analysis Limitations

Several limitations should be considered when interpreting the results:

- The dataset contains only **35 activity users**.
- Sleep, heart-rate, and weight data have lower user coverage.
- Heart-rate analysis is based on only **15 users**.
- The dataset represents a limited observation period.
- User behavior in this dataset may not represent Bellabeat's broader customer base.
- The analysis identifies associations and behavioral patterns; it does not establish causal relationships.
- Feature adoption differs across datasets because not every user recorded every type of wellness data.

-
