{:aliases
 {"doc-lit" ^:displace ["marg" "--dir" "doc/marginalia"]
  "docs" ^:displace ["do" ["codox"] ["doc-lit"] ["hiera"]]
  "coverage" ^:displace ["cloverage"]
  "tests" ["with-profile" "+repl-tools" "do" ["check"] ["test"] ["coverage"]]
  "slamhound" ["with-profile" "+repl-tools" "run" "-m" "slam.hound"]
  "repl-" ["with-profile" "+repl-tools" "repl"]}

 :plugins
 [[org.clojure/clojure "1.8.0"]
  [com.jakemccrary/lein-test-refresh "0.16.0"]
  [mvxcvi/whidbey "1.3.1"]
  [lein-ancient "0.6.10"]
  [lein-cljfmt "0.5.3"]
  [lein-codox "0.9.5"]
  [lein-cprint "1.2.0"]
  [lein-hiera "0.9.5"]
  [lein-kibit "0.1.2"]
  [lein-vanity "0.2.0"]
  [michaelblume/lein-marginalia "0.9.0"]
  [rfkm/lein-cloverage "1.0.8"]
  [michaelblume/lein-marginalia "0.9.0"
   :exclusions [org.clojure/clojurescript]]]

 :whidbey
 {:width 150
  :map-delimiter ","
  :color-scheme {:nil [:blue]}
  :tag-types {java.lang.Class {'class #(symbol (.getName %))}}}

 :hiera
 ^:displace
 {:show-external true
  :ignore-ns #{clojure user}}}
