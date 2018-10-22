-module(config).
-compile(export_all).

log_level() -> info.
log_modules() -> % any
  [
    store_mnesia,
    index
  ].
