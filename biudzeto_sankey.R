library(ggplot2)

library(magrittr)

library(echarts4r)

library(readODS)



setwd("C:/Users/sskripkauskiene/Documents/R/Valstybės biudžetas sankey")

biud <- read_ods("valsbiudz.ods", sheet = 4, col_names = TRUE)



VB2026 %>%
  
  e_charts() %>%
  
  e_sankey(source, target, value) %>%
  
  e_tooltip(
    
    trigger = "item",
    
    formatter = htmlwidgets::JS("

      function(params) {

        return params.name + ': ' + (params.value || 0).toLocaleString('lt-LT');

      }

    ")
    
  ) %>%
  
  e_labels(
    
    show = TRUE,
    
    position = "right",
    
    formatter = htmlwidgets::JS("

      function(params) {

        var v = (params.value != null ? params.value : 0);

        if (v <= 146) return '';

 

        // wrap long names

        var words = String(params.name || '').split(' ');

        var lines = [];

        var currentLine = '';

        var maxLen = 40;

 

        words.forEach(function(word) {

          var test = (currentLine + ' ' + word).trim();

          if (test.length <= maxLen) {

            currentLine = test;

          } else {

            if (currentLine) lines.push(currentLine);

            currentLine = word;

          }

        });

        if (currentLine) lines.push(currentLine);

 

        // style by size

        var style = (v > 1600) ? 'big' : 'normal';

 

        // add value on a new line (adjust unit if needed)

        var unit = ' mln. €'; // e.g., ' TJ' or ' €'

        var valueLine = '{value|' + v.toLocaleString('lt-LT') + unit + '}';

 

        return '{' + style + '|' + lines.join('\\n') + '}\\n' + valueLine;

      }

    "),
    
    rich = list(
      
      big = list(fontSize = 24),
      
      normal = list(fontSize = 14),
      
      value = list(fontSize = 14, fontWeight = "normal")
      
    )
    
  ) %>%
  
  e_theme_custom("customized.json") %>%
  
  htmlwidgets::saveWidget("biudzetasskaic.html", selfcontained = TRUE)