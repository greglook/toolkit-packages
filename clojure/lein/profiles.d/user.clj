{:signing
 {:gpg-key "greg@mvxcvi.com"}

 :plugins
 [[org.clojure/clojure "1.10.1"]
  [mvxcvi/whidbey "2.2.0"]
  [lein-ancient "0.6.15"]
  [lein-codox "0.10.7"]
  [lein-cprint "1.3.2"]
  [lein-hiera "1.1.0"]
  ;[lein-nvd "1.1.1" :exclusions [org.slf4j/slf4j-api org.slf4j/jcl-over-slf4j]]
  [lein-vanity "0.2.0"]
  [lein-cloverage "1.1.2"]
  [lein-collisions "0.1.4"]
  ;[lein-marginalia "0.9.1"]
  [lein-shell "0.5.0"]
  [com.jakemccrary/lein-test-refresh "0.24.1"]
  [venantius/yagni "0.1.7" :exclusions [org.clojure/tools.logging]]
  ,,,]

 :dependencies
 [[clj-stacktrace "0.2.8"]
  [pjstadig/humane-test-output "0.9.0"]]

 :injections
 [(let [pct-var (ns-resolve (doto 'clojure.stacktrace require) 'print-cause-trace)
        pst-var (ns-resolve (doto 'clj-stacktrace.repl require) 'pst+)]
    (alter-var-root pct-var (constantly (deref pst-var))))
  (require 'pjstadig.humane-test-output)
  (pjstadig.humane-test-output/activate!)]

 :middleware
 [whidbey.plugin/repl-pprint]

 :whidbey
 {:width 150
  :map-delimiter ","
  :namespace-maps true
  :color-scheme {:nil [:blue]}
  :tag-types {java.lang.Class {'jvm/class #(symbol (.getName %))}
              java.time.Instant {'inst str}
              'org.joda.time.DateTime {'joda/inst str}
              'org.joda.time.UTCDateTimeZone {'joda/zone str}}}

 :hiera
 ^:displace
 {:show-external true
  :ignore-ns #{clojure user}}}
