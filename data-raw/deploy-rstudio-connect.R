rsconnect::deployApp(
  appDir = here::here("docs"),                                          # the directory containing the content
  appFiles = list.files(here::here("docs"), recursive = TRUE),    # the list of files to include as dependencies (all of them)
  appPrimaryDoc = "index.html",                    # the primary file
  appName = "ironer",                              # name of the endpoint (unique to your account on Connect)
  appTitle = "ironer",                             # display name for the content
  account = "pileggis",                            # your Connect username
  server = "rconnect.mskcc.org"                    # the Connect server, see rsconnect::accounts()
)
