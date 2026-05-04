# ==============================================================================
# Shiny App: Smoking & Education Association Explorer
# Data: 2024 Behavioral Risk Factor Surveillance System (BRFSS)
# Author: Yihan Zhong
# ==============================================================================

library(shiny)
library(ggplot2)
library(dplyr)
library(haven)
library(scales)

# ==============================================================================
# UI
# ==============================================================================
ui <- fluidPage(
  title = "Smoking & Education | BRFSS 2024",

  tags$head(tags$style(HTML('
    @import url("https://fonts.googleapis.com/css2?family=Playfair+Display:wght@600&family=Source+Sans+3:wght@300;400;600&display=swap");
    *, *::before, *::after { box-sizing: border-box; }
    body { margin: 0; font-family: "Source Sans 3", sans-serif; background: #f5f3ee; color: #1c1c1c; }
    .top-banner { background: #1c2b3a; color: #f5f3ee; padding: 28px 48px 22px; border-bottom: 4px solid #c8975a; }
    .top-banner h1 { font-family: "Playfair Display", serif; font-size: 26px; margin: 0 0 6px 0; letter-spacing: -0.3px; }
    .top-banner p { margin: 0; font-size: 13px; color: #8fa8bc; font-weight: 300; }
    .goal-box { background: #fff; border-left: 5px solid #c8975a; margin: 28px 40px 0; padding: 18px 24px; border-radius: 0 8px 8px 0; font-size: 14px; line-height: 1.7; color: #3a3a3a; box-shadow: 0 1px 4px rgba(0,0,0,.06); }
    .goal-box strong { color: #1c2b3a; }
    .app-body { display: flex; gap: 0; margin: 24px 40px 40px; align-items: flex-start; }
    .sidebar-panel { width: 260px; min-width: 260px; background: #fff; border-radius: 10px; padding: 24px 20px; box-shadow: 0 1px 6px rgba(0,0,0,.07); margin-right: 24px; }
    .sidebar-panel h4 { font-family: "Playfair Display", serif; font-size: 15px; color: #1c2b3a; margin: 0 0 16px 0; padding-bottom: 8px; border-bottom: 1px solid #e8e4dc; }
    .ctrl-section { margin-bottom: 22px; }
    .ctrl-label { font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; color: #7a6e60; margin-bottom: 8px; }
    .radio label, .checkbox label { font-size: 13px; color: #3a3a3a; }
    .shiny-input-container { margin-bottom: 0 !important; }
    .irs--shiny .irs-bar, .irs--shiny .irs-bar--single { background: #c8975a !important; }
    .irs--shiny .irs-handle { border-color: #c8975a !important; }
    .irs--shiny .irs-from, .irs--shiny .irs-to, .irs--shiny .irs-single { background: #c8975a !important; }
    .irs--shiny .irs-line { background: #e8e4dc; }
    #run_btn { display: block; width: 100%; margin-top: 10px; padding: 13px 0; background: #1c2b3a; color: #f5f3ee; border: none; border-radius: 7px; font-family: "Source Sans 3", sans-serif; font-size: 14px; font-weight: 600; letter-spacing: 0.3px; cursor: pointer; transition: background 0.2s, transform 0.1s; }
    #run_btn:hover  { background: #243548; }
    #run_btn:active { transform: scale(0.98); }
    .github-btn { display: flex; align-items: center; justify-content: center; gap: 8px; width: 100%; margin-top: 10px; padding: 11px 0; background: #f5f3ee; color: #1c2b3a; border: 1.5px solid #c8c0b0; border-radius: 7px; font-family: "Source Sans 3", sans-serif; font-size: 13px; font-weight: 600; text-decoration: none; transition: background 0.2s, border-color 0.2s, transform 0.1s; }
    .github-btn:hover  { background: #e8e4dc; border-color: #a09880; }
    .github-btn:active { transform: scale(0.98); }
    .main-panel { flex: 1; min-width: 0; }
    .stat-row { display: flex; gap: 14px; margin-bottom: 20px; }
    .stat-card { flex: 1; background: #fff; border-radius: 10px; padding: 16px 18px; box-shadow: 0 1px 6px rgba(0,0,0,.07); border-top: 3px solid #c8975a; }
    .stat-card .s-label { font-size: 11px; font-weight: 600; text-transform: uppercase; letter-spacing: 1px; color: #7a6e60; margin-bottom: 6px; }
    .stat-card .s-value { font-family: "Playfair Display", serif; font-size: 26px; color: #1c2b3a; }
    .stat-card .s-sub { font-size: 12px; color: #a09880; margin-top: 2px; }
    .plot-card { background: #fff; border-radius: 10px; padding: 24px 26px 20px; box-shadow: 0 1px 6px rgba(0,0,0,.07); margin-bottom: 18px; }
    .plot-card h3 { font-family: "Playfair Display", serif; font-size: 17px; color: #1c2b3a; margin: 0 0 4px 0; }
    .plot-caption { font-size: 12px; color: #8a8070; margin-bottom: 16px; line-height: 1.5; }
    .result-box { background: #f0ede6; border-radius: 8px; padding: 16px 20px; margin-top: 16px; font-size: 13.5px; line-height: 1.8; color: #2a2a2a; }
    .result-box .res-title { font-weight: 600; font-size: 12px; text-transform: uppercase; letter-spacing: 0.8px; color: #7a6e60; margin-bottom: 6px; }
    .sig   { color: #1a6b3a; font-weight: 600; }
    .unsig { color: #8a4020; font-weight: 600; }
    .placeholder { text-align: center; padding: 80px 20px; color: #b0a898; font-size: 14px; background: #fff; border-radius: 10px; box-shadow: 0 1px 6px rgba(0,0,0,.07); }
    .placeholder .ph-icon { font-size: 42px; margin-bottom: 14px; }
    .footer { text-align: center; font-size: 12px; color: #b0a898; padding: 0 0 30px; }
  '))),

  # ---- Top banner ----
  div(class = "top-banner",
    tags$h1("Smoking & Education Association Explorer"),
    tags$p("2024 Behavioral Risk Factor Surveillance System (BRFSS)  \u00b7  Yihan Zhong")
  ),

  # ---- Goal box ----
  div(class = "goal-box",
    tags$strong("App Goal: "),
    "This app explores whether smoking prevalence is associated with education level
     among U.S. adults using BRFSS 2024 data. Use the controls on the left to select
     a ", tags$strong("chart type"), " and choose an ", tags$strong("education grouping"),
    ". Press ", tags$strong('"Run Analysis"'), " to update all visuals and statistics."
  ),

  # ---- Main body ----
  div(class = "app-body",

    # ---- Sidebar ----
    div(class = "sidebar-panel",
      tags$h4("Controls"),

      div(class = "ctrl-section",
        div(class = "ctrl-label", "Chart Type"),
        radioButtons("chart_type", label = NULL,
          choices = list(
            "Bar chart \u2013 smoking rate by group" = "bar",
            "Heatmap \u2013 proportion matrix"       = "heat",
            "Trend line \u2013 ordered education"    = "line"
          ),
          selected = "bar"
        )
      ),

      div(class = "ctrl-section",
        div(class = "ctrl-label", "Education Grouping"),
        radioButtons("edu_type", label = NULL,
          choices = list(
            "3 groups (Low / Medium / High)" = "three",
            "6 groups (original EDUCA)"      = "six"
          ),
          selected = "three"
        )
      ),

      actionButton("run_btn", "\u25b6  Run Analysis"),
      tags$a(
        href   = "https://github.com/muxiao1019-bot/Smoking-Education-Association-Explorer/tree/main",
        target = "_blank",
        class  = "github-btn",
        "\U0001f431 GitHub"
      )
    ),

    # ---- Main panel ----
    div(class = "main-panel",
      uiOutput("main_ui"),
      div(class = "footer",
        "Data: CDC BRFSS 2024  \u00b7  Variables: _RFSMOK3 (smoking status), EDUCA (education level)"
      )
    )
  )
)

# ==============================================================================
# Server
# ==============================================================================
server <- function(input, output, session) {

  # ---- Load & clean data ----
  brfss <- reactive({
    xpt_path <- "LLCP2024.XPT"

    if (file.exists(xpt_path)) {
      raw <- read_xpt(xpt_path)
      df <- raw %>%
        dplyr::select(`_RFSMOK3`, EDUCA) %>%
        dplyr::filter(
          !is.na(`_RFSMOK3`), !is.na(EDUCA),
          EDUCA %in% 1:6,
          `_RFSMOK3` %in% c(1, 2)
        ) %>%
        mutate(current_smoker = as.integer(`_RFSMOK3` == 1))
    } else {
      message("LLCP2024.XPT not found - using simulated data.")
      set.seed(2024)
      n   <- 60000
      edu <- sample(1:6, n, replace = TRUE,
                    prob = c(0.04, 0.06, 0.09, 0.28, 0.22, 0.31))
      p   <- c(0.31, 0.27, 0.23, 0.18, 0.12, 0.08)[edu]
      df  <- data.frame(EDUCA = edu,
                        current_smoker = rbinom(n, 1, p))
    }
    df
  })

  # ---- Apply user controls (triggered by button) ----
  processed <- eventReactive(input$run_btn, {
    df <- brfss()

    if (input$edu_type == "three") {
      df <- df %>% mutate(
        edu_label = case_when(
          EDUCA %in% 1:3 ~ "Low\n(< High school)",
          EDUCA == 4      ~ "Medium\n(High school/GED)",
          EDUCA %in% 5:6  ~ "High\n(College+)"
        ),
        edu_label = factor(edu_label,
          levels = c("Low\n(< High school)",
                     "Medium\n(High school/GED)",
                     "High\n(College+)"))
      )
    } else {
      lbl <- c("1: No school", "2: Elementary", "3: Some high school",
               "4: High school/GED", "5: Some college", "6: College grad+")
      df <- df %>%
        mutate(edu_label = factor(lbl[EDUCA], levels = lbl))
    }

    df
  })

  # ---- Shared ggplot theme ----
  my_theme <- function() {
    theme_minimal(base_size = 12) +
      theme(
        plot.background  = element_rect(fill = "#ffffff", color = NA),
        panel.background = element_rect(fill = "#ffffff", color = NA),
        panel.grid.major = element_line(color = "#ece8e0", linewidth = 0.5),
        panel.grid.minor = element_blank(),
        axis.text        = element_text(color = "#5a5040", size = 11),
        axis.title       = element_text(color = "#3a3028", size = 12),
        plot.subtitle    = element_text(color = "#8a7860", size = 11),
        legend.title     = element_text(color = "#5a5040", size = 11),
        legend.text      = element_text(color = "#5a5040", size = 11)
      )
  }

  pal3 <- c("Low\n(< High school)"      = "#c0392b",
            "Medium\n(High school/GED)" = "#e67e22",
            "High\n(College+)"          = "#2471a3")
  pal6 <- c("#c0392b", "#e67e22", "#d4ac0d",
            "#27ae60", "#2471a3", "#7d3c98")

  # ---- Main UI output ----
  output$main_ui <- renderUI({

    if (input$run_btn == 0) {
      return(div(class = "placeholder",
        div(class = "ph-icon", "\U0001f4ca"),
        tags$p("Set your options and press",
               tags$strong(" Run Analysis "), "to see results.")
      ))
    }

    df <- processed()

    smry <- df %>%
      group_by(edu_label) %>%
      summarise(n    = n(),
                prev = mean(current_smoker),
                se   = sqrt(prev * (1 - prev) / n),
                .groups = "drop")

    n_total <- nrow(df)
    n_smoke <- sum(df$current_smoker)
    pct_all <- round(mean(df$current_smoker) * 100, 1)

    ct  <- table(df$edu_label, df$current_smoker)
    res <- suppressWarnings(chisq.test(ct))
    p_v <- res$p.value
    p_label  <- ifelse(p_v < 0.001, "< 0.001", round(p_v, 4))
    sig_cls  <- ifelse(p_v < 0.05, "sig", "unsig")
    sig_word <- ifelse(p_v < 0.05,
      "statistically significant (p < 0.05)",
      "not statistically significant (p \u2265 0.05)")
    conclusion <- ifelse(p_v < 0.05,
      "Education level is significantly associated with current smoking status.",
      "Insufficient evidence to conclude an association in this sample.")

    tagList(
      div(class = "stat-row",
        div(class = "stat-card",
          div(class = "s-label", "Sample size"),
          div(class = "s-value", format(n_total, big.mark = ",")),
          div(class = "s-sub",   paste0(length(unique(df$edu_label)), " education groups"))
        ),
        div(class = "stat-card",
          div(class = "s-label", "Current smokers"),
          div(class = "s-value", format(n_smoke, big.mark = ",")),
          div(class = "s-sub",   paste0(pct_all, "% overall prevalence"))
        ),
        div(class = "stat-card",
          div(class = "s-label", "Chi-square p-value"),
          div(class = "s-value", p_label),
          div(class = "s-sub",
              ifelse(p_v < 0.05, "\u2713 Significant", "\u2717 Not significant"))
        )
      ),

      div(class = "plot-card",
        tags$h3(switch(input$chart_type,
          bar  = "Smoking Prevalence by Education Level",
          heat = "Proportion Heatmap: Smoking \u00d7 Education",
          line = "Smoking Rate Trend across Education Groups"
        )),
        div(class = "plot-caption",
          switch(input$chart_type,
            bar  = "Bar heights show the proportion of current smokers in each education group. Error bars are 95% confidence intervals.",
            heat = "Each cell shows the share of respondents with that smoking status within an education group.",
            line = "Connected points show how smoking prevalence changes across ordered education levels. Shaded band = 95% CI."
          )
        ),
        plotOutput("main_plot", height = "400px"),

        div(class = "result-box",
          div(class = "res-title", "Chi-square Test of Independence"),
          HTML(paste0(
            "<b>H\u2080:</b> Smoking status is independent of education level.<br>",
            "<b>\u03c7\u00b2</b> = ", round(res$statistic, 2),
            " &nbsp;|&nbsp; <b>df</b> = ", res$parameter,
            " &nbsp;|&nbsp; <b>p</b> = ", p_label, "<br>",
            "<b>Conclusion:</b> The association is ",
            "<span class='", sig_cls, "'>", sig_word, "</span>. ",
            conclusion
          ))
        )
      )
    )
  })

  # ---- Plot ----
  output$main_plot <- renderPlot({
    req(input$run_btn > 0)
    df <- processed()

    smry <- df %>%
      group_by(edu_label) %>%
      summarise(n    = n(),
                prev = mean(current_smoker),
                se   = sqrt(prev * (1 - prev) / n),
                .groups = "drop")

    pal <- if (input$edu_type == "three") pal3 else pal6

    if (input$chart_type == "bar") {
      ggplot(smry, aes(x = edu_label, y = prev, fill = edu_label)) +
        geom_col(width = 0.6, show.legend = FALSE) +
        geom_errorbar(aes(ymin = prev - 1.96 * se,
                          ymax = prev + 1.96 * se),
                      width = 0.18, color = "#555555", linewidth = 0.5) +
        geom_text(aes(label = paste0(round(prev * 100, 1), "%")),
                  vjust = -1.8, size = 4, fontface = "bold", color = "#2a2a2a") +
        scale_fill_manual(values = pal) +
        scale_y_continuous(labels = percent_format(accuracy = 1),
                           limits = c(0, max(smry$prev) * 1.35),
                           expand = c(0, 0)) +
        labs(x = "Education Level", y = "Smoking Prevalence",
             subtitle = paste0("n = ", format(nrow(df), big.mark = ","))) +
        my_theme()

    } else if (input$chart_type == "heat") {
      cross <- df %>%
        count(edu_label, current_smoker) %>%
        group_by(edu_label) %>%
        mutate(pct = n / sum(n)) %>%
        ungroup() %>%
        mutate(smoke_label = factor(
          ifelse(current_smoker == 1, "Current Smoker", "Non-Smoker"),
          levels = c("Non-Smoker", "Current Smoker")))

      ggplot(cross, aes(x = smoke_label, y = edu_label, fill = pct)) +
        geom_tile(color = "#f5f3ee", linewidth = 2) +
        geom_text(aes(label = paste0(round(pct * 100, 1), "%")),
                  size = 5, fontface = "bold", color = "white") +
        scale_fill_gradient(low = "#adc6e0", high = "#1c2b3a",
                            labels = percent_format(),
                            name = "Share\nwithin group") +
        labs(x = "Smoking Status", y = "Education Level") +
        my_theme() +
        theme(panel.grid = element_blank())

    } else {
      ggplot(smry, aes(x = edu_label, y = prev, group = 1)) +
        geom_ribbon(aes(ymin = prev - 1.96 * se,
                        ymax = prev + 1.96 * se),
                    fill = "#c8975a", alpha = 0.2) +
        geom_line(color = "#c8975a", linewidth = 1.3) +
        geom_point(aes(fill = edu_label), shape = 21, size = 5,
                   color = "#1c2b3a", stroke = 1.5, show.legend = FALSE) +
        geom_text(aes(label = paste0(round(prev * 100, 1), "%")),
                  vjust = -1.6, size = 3.8, fontface = "bold", color = "#2a2a2a") +
        scale_fill_manual(values = pal) +
        scale_y_continuous(labels = percent_format(accuracy = 1),
                           limits = c(0, max(smry$prev) * 1.35),
                           expand = c(0, 0)) +
        labs(x = "Education Level", y = "Smoking Prevalence",
             subtitle = "Shaded band = 95% confidence interval") +
        my_theme()
    }
  }, bg = "#ffffff")
}

# ==============================================================================
shinyApp(ui, server)
