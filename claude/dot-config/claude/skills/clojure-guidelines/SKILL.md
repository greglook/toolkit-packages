---
name: clojure-guidelines
description: Guidelines for writing Clojure idiomatically. Use this when the project contains Clojure code files (`.clj`, `.cljc`, `.cljs`, `.edn`)
user-invocable: false
hooks:
  PreToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: clj-paren-repair-claude-hook
  PostToolUse:
    - matcher: "Write|Edit"
      hooks:
        - type: command
          command: clj-paren-repair-claude-hook
  SessionEnd:
    - hooks:
        - type: command
          command: clj-paren-repair-claude-hook
---

When writing Clojure code, use the folowing instructions.


## Idioms

Never shadow `clojure.core` vars with local binding names. Come up with names which don't conflict.

Use `<` and `<=` instead of `>` and `>=`, so that smaller values come before larger ones:
```clojure
;; bad
(> x y)

;; good
(< x y)
```

Prefer transducers to sequence operations where possible:
```clojure
;; bad
(->> coll (map f) (into {}))

;; good
(into {} (map f) coll)
```

Name any function literals which span multiple lines:
```clojure
;; bad
(keep (fn [x]
        (+ x 3))
      coll)

;; good
(keep (fn add-three
        [x]
        (+ x 3))
      coll)

;; one-liners can be anonymous
(keep (fn [x] (+ x 3)) coll)
```


## Style

Use two spaces for indentation.

Use `cljstyle` to format source files:
```bash
cljstyle fix src/foo/bar.clj
```

Don't bother using `cljstyle check`, just apply fix.


## Common Tools

Use `clj-kondo` to lint code:
```bash
clj-kondo --lint src
```
