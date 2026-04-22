# 🚬 Smoking & Education Association Explorer

An interactive R Shiny application that explores the relationship between **smoking prevalence** and **education level** among U.S. adults using data from the **2024 Behavioral Risk Factor Surveillance System (BRFSS)**.

**Author:** Yihan Zhong  
**GitHub:** [muxiao1019-bot](https://github.com/muxiao1019-bot)

---

## 📌 App Goal

This app investigates whether smoking prevalence is associated with education level. Users can customize the chart type, education grouping, and which education groups to include, then run a chi-square test to assess statistical significance.

---

## 📊 Features

- **Three chart types:**
  - Bar chart — smoking rate per education group with 95% confidence intervals
  - Heatmap — proportion matrix of smoking status × education level
  - Trend line — smoking prevalence across ordered education groups with a shaded confidence band

- **Two education groupings:**
  - 3 groups: Low (< High school) / Medium (High school/GED) / High (College+)
  - 6 groups: Original BRFSS EDUCA categories (No school → College grad+)

- **Filtering:** Select which education groups to include in the analysis

- **Summary statistics cards:** Sample size, number of current smokers, and chi-square p-value

- **Chi-square test of independence:** Automatically computed and displayed with interpretation

---

## 🗂️ Data

| Field | Details |
|-------|---------|
| Source | CDC Behavioral Risk Factor Surveillance System (BRFSS) |
| Year | 2024 |
| File | `LLCP2024.XPT` (SAS transport format) |
| Key variables | `_RFSMOK3` (current smoking status), `EDUCA` (education level) |

> **Note:** If `LLCP2024.XPT` is not present in the app directory, the app will automatically fall back to a simulated dataset of 60,000 observations for demonstration purposes.

---

## 🚀 How to Run

### Prerequisites

Install the required R packages:

```r
install.packages(c("shiny", "ggplot2", "dplyr", "haven", "scales"))
```

### Launch the App

1. Place `LLCP2024.XPT` in the same folder as `app.R` (optional but recommended for real data).
2. Open `app.R` in RStudio.
3. Click **Run App**, or run in the R console:

```r
shiny::runApp("path/to/app.R")
```

---

## 🖥️ Usage

1. Select a **Chart Type** from the sidebar.
2. Choose an **Education Grouping** (3-group or 6-group).
3. Check/uncheck **Education Groups** to include in the analysis.
4. Click **▶ Run Analysis** to generate the plot and statistics.

---

## 📁 File Structure

```
.
├── app.R            # Main Shiny application
└── LLCP2024.XPT     # BRFSS 2024 data file (place here before running)
```

---

## 📄 License

This project is for academic and educational purposes.  
Data sourced from the [CDC BRFSS](https://www.cdc.gov/brfss/index.html).
