# log - v1.0.52
a library for logging functions


### mflibs::log()

runs and logs command

#### arguments:

- 1: command to log

#### example:

```bash
mflibs::log "echo hi"
```

### Log file contract

The library writes to `mflibs_log_location`. Set it, and `export` it, before loading mflibs; when it is unset the log goes to `<mflibs>/src/logs/<script>`.

Loading the library runs `mflibs::log::init`, which is safe to run any number of times in one process tree (an entry script, the scripts it launches, nested helpers):

- the first init of a path appends one `### <date> ###` header and, if the file is over the rotation size, moves it to `<path>.1` (replacing the previous `.1`) and recreates it with the owner and mode the rotated file had
- the path is then recorded in the exported `mflibs_log_initialized`; a later init of the same path, in this process or any descendant, returns early after checking the file is still writable, so there is no extra header and no rotation under a writer that already has the file open
- a different path (a script that sets its own `mflibs_log_location`) is a first init of that path
- an unwritable location falls back to `/tmp/mflibs-<user>-<script>.log`, then to `/dev/null`; logging problems never stop the calling script
- a log file that disappears mid-run is recreated, with a new header, by the next init

#### environment:

- `mflibs_log_location`: log file path
- `mflibs_log_max_bytes`: rotate at init past this size (default `5242880`, 5 MiB; non-numeric values fall back to the default)
- `mflibs_log_initialized`: set by the library, do not set it by hand
