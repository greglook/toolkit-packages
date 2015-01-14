{:aliases {"slamhound" ["run" "-m" "slam.hound"]}

 :dependencies [[clj-stacktrace "0.2.7"]
                [slamhound "1.5.5"]
                [org.clojure/tools.trace "0.7.6"]]

 :plugins [[lein-ancient "0.5.5"]
           [lein-cloverage "1.0.2"]
           [lein-cprint "1.0.0"]
           [lein-hiera "0.9.0"]
           [lein-kibit "0.0.8"]
           [lein-marginalia "0.8.0"]
           [lein-vanity "0.2.0"]
           [com.jakemccrary/lein-test-refresh "0.5.3"]
           [jonase/eastwood "0.1.4"]]

 :injections
 [(let [pct-var (ns-resolve (doto 'clojure.stacktrace require) 'print-cause-trace)
        pst-var (ns-resolve (doto 'clj-stacktrace.repl require) 'pst+)]
    (alter-var-root pct-var (constantly (deref pst-var))))]

 :hiera ^:displace
 {:show-external? true
  :ignore-ns #{clojure user}}}
