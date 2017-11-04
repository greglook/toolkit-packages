{:aliases
 {"doc-lit" ^:displace ["marg" "--dir" "target/doc/marginalia"]
  "coverage" ^:displace ["cloverage"]
  "tests" ["with-profile" "+repl-tools" "do" ["check"] ["test"] ["coverage"]]
  "slamhound" ["with-profile" "+repl-tools" "run" "-m" "slam.hound"]
  "repl-" ["with-profile" "+repl-tools" "repl"]}

 :plugins
 [[org.clojure/clojure "1.8.0"]
  [com.jakemccrary/lein-test-refresh "0.21.1"]
  [mvxcvi/whidbey "1.3.2"]
  [lein-ancient "0.6.14"]
  [lein-cljfmt "0.5.7"]
  [lein-codox "0.10.3"]
  [lein-cprint "1.3.0"]
  [lein-hiera "1.0.0"]
  [lein-kibit "0.1.5"]
  [lein-vanity "0.2.0"]
  [lein-cloverage "1.0.10"]
  [michaelblume/lein-marginalia "0.9.0"
   :exclusions [org.clojure/clojurescript]]
  [venantius/yagni "0.1.4"]
  [walmartlabs/vizdeps "0.1.6"]]

 :dependencies
 [[pjstadig/humane-test-output "0.8.3"]]

 :injections
 [(require 'pjstadig.humane-test-output)
  (pjstadig.humane-test-output/activate!)]

 :whidbey
 {:width 150
  :map-delimiter ","
  :color-scheme {:nil [:blue]}
  :tag-types {java.lang.Class {'jvm/class #(symbol (.getName %))}
              java.time.Instant {'inst str}}}

 :hiera
 ^:displace
 {:show-external true
  :ignore-ns #{clojure user}}}
