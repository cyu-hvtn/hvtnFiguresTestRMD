# ------------------------------------------------------------------------------
# create_report.R
#
# Edit and run this script to compile Rmarkdown reports
#
# ------------------------------------------------------------------------------

library(rmarkdown)
library(hvtnReports)
library(officer) # To output png's to powerpoint

rmd <- "test_cases.Rmd"
outfile <- sprintf("%s-%s>", rmd, Sys.Date())

# YAML options from original skeleton for multiple doc types.
# output:
#   pdf_document:
#   keep_tex: true
# word_document:
#   reference_docx: word-pt-stlyles-reference-01.docx
# html_document: default

# Render pdf
render(
  input = rmd,
  output_format = "all", # Generate all outputs in YAML header
  output_dir = "."
)

### Output figures to Powerpoint -----------------------------------------------
imgpath <- "graph"
imgs <- list.files(imgpath, pattern = "\\.png", full.names = TRUE)

# See example of using officer package to create powerpoints:
# https://cran.r-project.org/web/packages/officer/vignettes/powerpoint.html
ppt_template <- system.file("office_templates", "vtn_figure_template.pptx",
                            package="hvtnReports")
doc <- read_pptx(ppt_template)
lapply(imgs, function(x) {
  doc <- add_slide(doc, layout = "figure", master = "R_figure")
  doc <- ph_with(doc, external_img(src = x), location=ph_location_type(type = "body"), index = 1)
})
invisible(print(doc, target = sprintf("%s.pptx", outfile)))


sessionInfo()
rmarkdown::pandoc_version()
