[
  line_length: 140,
  import_deps: [
    :nimble_parsec,
    :phoenix,
    :phoenix_live_view
  ],
  inputs: ["*.{ex,exs}", "{config,lib,test}/**/*.{ex,exs}"],
  plugins: [Phoenix.LiveView.HTMLFormatter, Styler]
]
