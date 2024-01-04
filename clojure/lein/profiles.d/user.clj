{:signing
 {:gpg-key "greg@mvxcvi.com"}

 :aliases
 {#_#_
  "kaocha" ["update-in" ":dependencies" "conj"
            "[org.clojure/test.check \"1.1.0\"]"
            "[lambdaisland/kaocha \"1.0.829\"]"
            "[mvxcvi/puget \"1.3.1\"]"
            "--"
            "run" "-m" "kaocha.runner"]}

 :plugins
 [[org.clojure/clojure "1.11.1"]
  [mvxcvi/whidbey "2.2.1"]
  [lein-ancient "0.7.0"]
  [lein-codox "0.10.7"]
  [lein-cprint "1.3.3"]
  [mvxcvi/puget "1.3.4"]
  [lein-hiera "2.0.0"]
  [lein-vanity "0.2.0"]
  [lein-cloverage "1.2.1"]
  [lein-collisions "0.1.4"]
  #_[lein-marginalia "0.9.1"]
  [lein-shell "0.5.0"]
  [com.jakemccrary/lein-test-refresh "0.25.0"]
  [venantius/yagni "0.1.7" :exclusions [org.clojure/tools.logging]]
  ,,,]

 :dependencies
 [[clj-stacktrace "0.2.8"]
  [pjstadig/humane-test-output "0.10.0"]]

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
  :tag-types {java.lang.Class {'class #(symbol (.getName %))}
              java.time.Instant {'inst str}
              java.time.Duration {'time/duration str}
              java.time.LocalDate {'time/local-date str}
              java.time.LocalDateTime {'time/local-date-time str}
              java.time.LocalTime {'time/local-time str}
              java.time.Month {'time/month str}
              java.time.Period {'time/period str}
              java.time.Year {'time/year str}
              java.time.YearMonth {'time/year-month str}
              java.time.ZoneId {'time/zone-id str}
              java.time.ZoneRegion {'time/zone-region str}
              java.time.ZoneOffset {'time/zone-offset str}
              java.time.ZonedDateTime {'time/zoned-date-time str}
              'org.joda.time.DateTime {'joda/inst str}
              'org.joda.time.LocalDate {'joda/local-date str}
              'org.joda.time.LocalDateTime {'joda/local-date-time str}
              'org.joda.time.UTCDateTimeZone {'joda/zone str}}}

 :hiera
 ^:displace
 {:show-external true
  :ignore-ns #{clojure user}}}
