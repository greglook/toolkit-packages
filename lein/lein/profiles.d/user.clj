{:aliases {"all" ["do" ["clean"] ["check"] ["test"] ["cloverage"] ["ns-dep-graph"]]}
 :plugins [[lein-cloverage "1.0.2"]
           [lein-exec "0.3.1"]
           [lein-kibit "0.0.8"]
           [lein-ns-dep-graph "0.1.0-SNAPSHOT"]
           [lein-pprint "1.1.1"]]
 :injections
 [(defmacro dbg [x]
    `(let [x# ~x]
      (printf "dbg %s/%s> %s => "
              ~*ns*
              ~(:line (meta &form))
              ~(pr-str x))
      (clojure.pprint/pprint x#)
      (flush)
      x#))]}
