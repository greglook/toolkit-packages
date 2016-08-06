^:repl
{:dependencies
 [[clj-stacktrace "0.2.8"]
  [slamhound "1.5.5"]
  [org.clojure/tools.namespace "0.2.11"]]

 :injections
 [(let [pct-var (ns-resolve (doto 'clojure.stacktrace require) 'print-cause-trace)
        pst-var (ns-resolve (doto 'clj-stacktrace.repl require) 'pst+)]
    (alter-var-root pct-var (constantly (deref pst-var))))]}
