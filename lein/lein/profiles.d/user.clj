{:aliases
 {"doc-lit" ^:displace ["marg" "--dir" "doc/marginalia"]
  "docs" ^:displace ["do" ["codox"] ["doc-lit"] ["hiera"]]
  "coverage" ^:displace ["cloverage"]
  "tests" ["do" ["check"] ["test"] ["coverage"]]
  "slamhound" ["run" "-m" "slam.hound"]}

 :plugins
 [[com.jakemccrary/lein-test-refresh "0.16.0"
   :exclusions [org.clojure/clojure]]
  [lein-ancient "0.6.10"
   :exclusions [org.clojure/clojure]]
  [lein-codox "0.9.5"
   :exclusions [org.clojure/clojure]]
  [lein-cprint "1.2.0"
   :exclusions [org.clojure/clojure]]
  [lein-hiera "0.9.5"
   :exclusions [org.clojure/clojure]]
  [michaelblume/lein-marginalia "0.9.0"
   :exclusions [org.clojure/clojure]]
  [lein-vanity "0.2.0"
   :exclusions [org.clojure/clojure]]
  [mvxcvi/whidbey "1.3.0"
   :exclusions [org.clojure/clojure]]
  [rfkm/lein-cloverage "1.0.8"
   :exclusions [org.clojure/clojure]]]

 :dependencies
 [[clj-stacktrace "0.2.8"]
  [slamhound "1.5.5"]]

 :injections
 [(let [pct-var (ns-resolve (doto 'clojure.stacktrace require) 'print-cause-trace)
        pst-var (ns-resolve (doto 'clj-stacktrace.repl require) 'pst+)]
    (alter-var-root pct-var (constantly (deref pst-var))))]

 :whidbey
 {:width 150
  :map-delimiter ","
  :color-scheme {:nil [:blue]}
  :tag-types {java.lang.Class {'class #(symbol (.getName %))}}}

 :hiera
 ^:displace
 {:show-external true
  :ignore-ns #{clojure user}}}
