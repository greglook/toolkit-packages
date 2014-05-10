{:aliases
 {"all" ["do" ["clean"] ["check"] ["test"] ["cloverage"] ["hiera"]]}

 :dependencies
 [[clj-stacktrace "0.2.7"]
  [org.clojure/tools.trace "0.7.6"]]

 :plugins
 [[lein-ancient "0.5.5"]
  [lein-cloverage "1.0.2"]
  [lein-cprint "1.0.0"]
  [lein-exec "0.3.1"]
  [lein-hiera "0.8.0"]
  [lein-kibit "0.0.8"]
  [lein-vanity "0.2.0"]
  [com.jakemccrary/lein-test-refresh "0.3.9"]
  [jonase/eastwood "0.1.0"]]

 :injections
 [(let [orig (ns-resolve (doto 'clojure.stacktrace require) 'print-cause-trace)
        new  (ns-resolve (doto 'clj-stacktrace.repl require) 'pst+)]
    (alter-var-root orig (constantly (deref new))))]

 :hiera
 {:show-external? true
  :vertical? false
  :ignore-ns #{clojure user}}}
