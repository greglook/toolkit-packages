{:aliases
 {"doc-lit" ^:displace ["marg" "--dir" "doc/marginalia"]
  "docs" ^:displace ["do" ["codox"] ["doc-lit"] ["hiera"]]
  "coverage" ^:displace ["cloverage"]
  "tests" ["do" ["check"] ["test"] ["coverage"]]
  "slamhound" ["run" "-m" "slam.hound"]}

 :plugins
 [[com.jakemccrary/lein-test-refresh "0.11.0"
   :exclusions [org.clojure/clojure]]
  [lein-ancient "0.6.7"]
  [lein-cloverage "1.0.6"]
  [lein-codox "0.9.0"]
  [lein-cprint "1.2.0"]
  [lein-hiera "0.9.5"]
  [lein-kibit "0.1.2"]
  [lein-marginalia "0.8.0"]
  [lein-vanity "0.2.0"]
  [mvxcvi/whidbey "1.3.0"]]

 :dependencies
 [[clj-stacktrace "0.2.8"]
  [slamhound "1.5.5"]
  [org.clojure/tools.namespace "0.2.10"]
  [org.clojure/tools.trace "0.7.9"]]

 :injections
 [(let [pct-var (ns-resolve (doto 'clojure.stacktrace require) 'print-cause-trace)
        pst-var (ns-resolve (doto 'clj-stacktrace.repl require) 'pst+)]
    (alter-var-root pct-var (constantly (deref pst-var))))]

 :whidbey
 {:width 200
  :map-delimiter ","}

 :codox
 {:defaults {:doc/format :markdown}
  :exclude #{user}
  :output-dir "doc/api"
  :src-linenum-anchor-prefix "L"}

 :hiera
 ^:displace
 {:show-external true
  :ignore-ns #{clojure user}}}
