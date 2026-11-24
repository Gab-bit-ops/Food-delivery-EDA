# 🛵 Food Delivery Operations & Exploratory Data Analysis (EDA) Week 2

## 📌 Project Overview
This repository presents an end-to-end **Exploratory Data Analysis (EDA)** of food delivery operations across **45,584 delivery records**[span_0](start_span)[span_0](end_span). Using **MySQL 8.0** for statistical querying and geospatial distance calculation alongside **Power BI** for visual correlation analysis, this project investigates the primary operational drivers behind delivery duration (`Time_taken_min`)[span_1](start_span)[span_1](end_span)[span_2](start_span)[span_2](end_span)[span_3](start_span)[span_3](end_span).

The analysis evaluates delivery baselines, road traffic density, weather conditions, vehicle types, geospatial trip distance, courier ratings, and multi-order batching to uncover actionable operational bottlenecks and analytical caveats
---

## 🛠️ Tech Stack & Methodology
* **Database & SQL Analytics:** MySQL 8.0 (Window functions `ROW_NUMBER()`, `AVG() OVER()`, conditional aggregations, and geospatial calculations via `ST_Distance_Sphere`
* **Data Visualization:** Power BI Desktop (Scatter plot correlation & distribution analysis)
* **Documentation & Reporting:** Structured analytical observation report & SQL scripts

---

## 📂 Repository Structure
* **`FOOD DELIVERY EXPLORATORY DATA ANALYSIS GENERAL OBSERVATION.docx`**: Comprehensive analytical findings, business interpretations, and statistical caveats across all seven operational questions[span_11](start_span)[span_11](end_span).
* **`*.sql`**: Production MySQL scripts covering baseline quality checks, group means/medians, distance banding, rating segmentation, and spherical distance calculations (`ST_Distance_Sphere`)[span_12](start_span)[span_12](end_span).
* **`Distance_Km vs Time_min.png`**: Power BI scatter plot illustrating the relationship between calculated trip distance (`distance_km`) and delivery time (`Time_taken_min`)[span_13](start_span)[span_13](end_span).

---

## 📊 Key Analytical Findings & Insights

### 1. Delivery Duration Baseline
* **Total Volume:** 45,584 valid deliveries[span_14](start_span)[span_14](end_span).
* **Central Tendency & Spread:** Mean delivery time is **26.29 minutes** and median is **26 minutes**, with an interquartile range (Q1–Q3) of **19 to 32 minutes** (Min: 10 mins, Max: 54 mins)[span_15](start_span)[span_15](end_span).
* **Interpretation:** Because the mean and median are nearly identical, delivery times are symmetrically distributed without extreme outliers skewing the average[span_16](start_span)[span_16](end_span). *(Note: No SLA target time exists in the dataset to benchmark whether 26 minutes meets business targets[span_17](start_span)[span_17](end_span).)*

### 2. Multi-Order Batching (`Multiple_deliveries`) — *Strongest Driver*
Carrying multiple deliveries simultaneously creates the largest time gap of any operational factor[span_18](start_span)[span_18](end_span):
| Concurrent Deliveries | Average Time (Min) | Delivery Count |
| :--- | :---: | :---: |
| **0 other deliveries** | 22.88 | 14,094 |
| **1 other delivery** | 26.85 | 28,151 |
| **2 other deliveries** | 40.45 | 1,985 |
| **3 other deliveries** | 47.82 | 361 |

* **Takeaway:** Batching 2 or 3 orders nearly doubles delivery duration compared to single-order trips[span_19](start_span)[span_19](end_span).

### 3. Road Traffic Density
| Traffic Condition | Average Time (Min) | Delivery Count |
| :--- | :---: | :---: |
| **Low** | 21.27 | 15,476 |
| **Medium** | 26.70 | 10,945 |
| **High** | 27.24 | 4,423 |
| **Jam** | 31.18 | 14,139 |

* **Takeaway:** Deliveries in **Jam** conditions take roughly **10 minutes longer** on average than in **Low** traffic, while Medium and High traffic perform nearly identically (~27 minutes)[span_20](start_span)[span_20](end_span).

### 4. Delivery Partner Ratings
| Rating Band | Average Time (Min) | Delivery Count |
| :--- | :---: | :---: |
| **Below 4.0** | 36.83 | 1,367 |
| **4.0 – 4.4** | 34.65 | 6,694 |
| **4.5 – 4.7** | 24.23 | 17,380 |
| **4.8 – 5.0** | 24.39 | 18,182 |

* **Takeaway:** Partners rated **4.5 and above** complete deliveries ~10–12 minutes faster than lower-rated partners, with performance plateauing above 4.5[span_21](start_span)[span_21](end_span). *(Analytical Caveat: Correlation does not establish direction—longer delivery times may directly cause customers to leave lower ratings[span_22](start_span)[span_22](end_span).)*

### 5. Geospatial Distance vs. Delivery Duration (`r = 0.32`)
* **Distance Band Breakdown:**
  * `0–5 km`: **22.19 mins** (11,300 deliveries)[span_23](start_span)[span_23](end_span)
  * `5–10 km`: **24.39 mins** (11,305 deliveries)[span_24](start_span)[span_24](end_span)
  * `10–15 km`: **29.83 mins** (11,293 deliveries)[span_25](start_span)[span_25](end_span)
  * `15+ km`: **29.86 mins** (8,046 deliveries)[span_26](start_span)[span_26](end_span)
* **Visual & Statistical Observation:** Calculated via `ST_Distance_Sphere` (excluding ~3,640 rows with `0` restaurant coordinates), distance exhibits a **weak positive correlation (`0.32`)** with duration and plateaus beyond 10 km[span_27](start_span)[span_27](end_span)[span_28](start_span)[span_28](end_span). In Power BI, points align into ~19 vertical bands spaced ~1.5 km apart, confirming that straight-line coordinate approximations explain only a small fraction of delivery time compared to traffic and order batching[span_29](start_span)[span_29](end_span)[span_30](start_span)[span_30](end_span).

### 6. Weather Conditions & Vehicle Type
* **Weather:** **Sunny** conditions yield the fastest deliveries (**21.86 mins**), whereas **Cloudy (28.92 mins)** and **Fog (28.91 mins)** are slower than **Stormy (25.87 mins)** and **Sandstorms (25.88 mins)**—indicating weather severity alone does not linearly dictate speed[span_31](start_span)[span_31](end_span).
* **Vehicle Type:** **Scooters (24.48 mins)** and **Electric Scooters (24.47 mins)** outperform **Motorcycles (27.61 mins)** by ~3 minutes, though motorcycles handle the majority of volume (26,429 deliveries) and may be assigned longer routes[span_32](start_span)[span_32](end_span). *(Bicycle sample size is too small at 68 deliveries for reliable comparison[span_33](start_span)[span_33](end_span).)*

## Week 3: Data Visualization

This week I turned the findings into five charts in Power BI, using the cleaned data (45,584 deliveries). Each chart answers one question about delivery time. Two words are used below: the **average** is the usual value (add everything up and divide), and the **median** is the middle value when all deliveries are lined up from fastest to slowest.

### Chart 1: How long do deliveries take?

This chart groups all deliveries into 5-minute bands and counts how many fall in each. Most deliveries (72.5%) take between 15 and 34 minutes, and the most common band is 25 to 29 minutes with 10,068 deliveries. A smaller number take longer, up to 54 minutes, and none take longer than that.

**Limitation:** the data has no target delivery time, so we can't say whether these times are good or bad.

### Chart 2: Median delivery time by traffic level

This chart shows the middle delivery time for each traffic level. The median is 20 minutes in Low traffic, 27 minutes in Medium and High, and 31 minutes in Jam, so busier traffic goes with longer deliveries. The groups have 15,476 (Low), 10,945 (Medium), 4,423 (High) and 14,139 (Jam) deliveries.

**Limitation:** this shows that the two go together, not that traffic is the cause. Time of day or trip distance could also play a part, and about 600 deliveries with no traffic information were left out.

### Chart 3: Average delivery time by weather

This chart shows the average delivery time for each weather condition. Sunny days are fastest at 21.86 minutes, while Cloudy (28.92) and Fog (28.91) are slowest. Windy (26.12), Sandstorms (25.88) and Stormy (25.87) fall in between, so the harshest-sounding weather is not the slowest.

**Limitation:** an average can hide big differences between individual deliveries, and about 600 deliveries with no weather information were left out. This shows a pattern, not a cause.

### Chart 4: Delivery distance vs delivery time

Each dot on this chart is a distance and a delivery time. Longer trips tend to take a little longer, but the link is weak (a correlation of 0.32, where 0 means no link and 1 means a perfect link). Trips under 3 km average about 21.5 minutes and trips over 10 km average about 30 minutes, with delivery times spread widely (about 10 to 54 minutes) at every distance. The dots form vertical lines because distances in this data fall into about 19 fixed values, roughly 1.5 km apart.

**Limitation:** distance is a straight-line estimate, not real road distance. About 3,640 deliveries with missing restaurant locations were left out, and the chart can't show how many deliveries sit on the same spot.

### Chart 5: Delivery time by vehicle type

This chart compares vehicle types using the median and the range that holds the middle half of deliveries. Scooters and electric scooters are almost the same (median 24 minutes, middle half 17 to 30 minutes). Motorcycles are a little slower (median 26 minutes, middle half 20 to 34 minutes), and bicycles have a median of 26 minutes.

**Limitation:** only 68 deliveries used a bicycle, which is too few to trust. The gaps between vehicles are small and don't show that the vehicle itself is the reason. Power BI has no built-in box plot, so I used a column chart of the median and the middle-half range instead.

### Main takeaways
- A typical delivery takes about 26 minutes.
- Heavy traffic goes with the longest deliveries, and sunny weather goes with the fastest.
- Distance and vehicle type make only a small difference.
- These charts show patterns, not causes.

