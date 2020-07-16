phylormd::render(
  "example.Rmd",
  front_matter_render_fields = "abstract",
  front_matter_env = list2env(list(n_data = 10)),
  output="example.md"
)
