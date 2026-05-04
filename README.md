# 🚬 Smoking & Education Association Explorer

An R-based project exploring the relationship between **smoking prevalence** and **education level** among U.S. adults using data from the **2024 Behavioral Risk Factor Surveillance System (BRFSS)**.

**Author:** Yihan Zhong  
**GitHub:** [muxiao1019-bot](https://github.com/muxiao1019-bot/Smoking-Education-Association-Explorer/tree/main)

---

## 📌 Project Goal

This project investigates whether smoking prevalence is associated with education level among U.S. adults. It includes a **final report** with formal statistical analyses and an **interactive Shiny app** for data exploration.

---

## 📄 Final Report

The final report addresses the research question: *Does the probability of being a current smoker decrease as educational attainment increases?*

**File:** [`Final_Report_Yihan_Zhong.pdf`](./Final_Report_Yihan_Zhong.pdf)  
**Source code:** [`Final_Report_Yihan_Zhong.Rmd`](./Final_Report_Yihan_Zhong.Rmd)

### Report Structure
- **Introduction** — Research question and scientific background
- **Material & Methods** — Data source (2024 BRFSS), variable definitions, and statistical approaches
- **Results** — Visualization, chi-square test, logistic regression, and forest plot
- **Conclusions** — Interpretation of findings and public health implications

### Key Findings
- Smoking prevalence decreases monotonically with education: Low (22.7%) → Medium (16.5%) → High (8.1%)
- Chi-square test: χ² = 9223.4, p < 0.001, Cramér's V = 0.148
- Logistic regression: Low education OR = 3.34 (95% CI: 3.23–3.45) vs. High education

---

## 🖥️ Shiny App

An interactive app that allows users to explore the data with customizable visualizations and statistical tests.

**Features:**
- Three chart types: bar chart, heatmap, and trend line
- Two education groupings: 3-group or 6-group (original BRFSS categories)
- Filtering by education group
- Summary statistics and chi-square test results

### How to Run
Install required packages:
```r
install.packages(c("shiny", "ggplot2", "dplyr", "haven", "scales"))
```
Launch the app:
```r
shiny::runApp("app.R")
```
> **Note:** Place `LLCP2024.XPT` in the same folder as `app.R` for real data. Otherwise the app uses a simulated dataset.

---

## 🗂️ Data

| Field | Details |
|-------|---------|
| Source | CDC Behavioral Risk Factor Surveillance System (BRFSS) |
| Year | 2024 |
| File | `LLCP2024.XPT` (SAS transport format) |
| Key variables | `_RFSMOK3` (smoking status), `EDUCA` (education level) |

## 📁 File Structure

| File | Description |
|------|-------------|
| `Final_Report_Yihan_Zhong.Rmd` | Report source code |
| `Final_Report_Yihan_Zhong.pdf` | Compiled report |
| `app.R` | Shiny application |
| `references.bib` | Bibliography |
| `LLCP2024.XPT` | BRFSS 2024 data (place here before running) |

---

## 📄 License

This project is for academic and educational purposes.  
Data sourced from the [CDC BRFSS](https://www.cdc.gov/brfss/index.html).
└── LLCP2024.XPT                   # BRFSS 2024 data (place here before running)
---
