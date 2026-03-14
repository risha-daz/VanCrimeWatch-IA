# VanCrimeWatch Lite

A Shiny for R dashboard exploring Vancouver crime data (2023–2025). Based on group project dashboard ([DSCI-532_2026_4_VanCrimeWatch](https://github.com/UBC-MDS/DSCI-532_2026_4_VanCrimeWatch))

## Components of the app:
**Input**
- **Crime Type Dropdown:** a single select option that lets the user filter all outputs by a specific crime type (e.g. "Break and Enter Commercial")

**Outputs**
- **Night-time Crimes KPI:** a KPI (value box) counting incidents between 20:00–05:59 for the selected crime type
- **Peak Crime Month KPI:** a KPI (value box) showing which calendar month had the highest number of incidents for the selected crime type
- **Monthly Crime Trend Chart:** a line chart showing incident counts per month, with one line per year, allowing comparison of seasonal patterns across years

**Reactive**
- **`filtered_data()`:** a reactive dataframe that filters the full dataset to only rows matching the selected crime type. All three outputs are made from this.

## Installation & Local Development

### 1. Clone the repository
In a new terminal in your desired target directory run:
```bash
git clone https://github.com/risha-daz/VanCrimeWatch-IA.git
cd VanCrimeWatch-IA/src/
```
### 2. Install dependencies
Open an R console or RStudio, then run:
```r
install.packages(c("shiny", "bslib", "dplyr", "ggplot2", "lubridate", "here"))
```

### 3. Run the app
In the same R console, run:
```r
shiny::runApp("app.R")
```
## Dataset
The dataset is sourced from publicly available data provided by the [Vancouver Police Department](https://geodash.vpd.ca/opendata/), covering crime incidents from 2023 to 2025.

## License
Licensed under the terms of the [MIT License](./LICENSE).

## Author
Sarisha Das
