phylormd::render(
  "example.Rmd",
  front_matter_render_fields = "abstract",
  envir = list2env(list(n_data_nz = 78, n_data_world = 200)),
  output="example.md"
)
