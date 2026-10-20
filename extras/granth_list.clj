;; Standalone sample; not part of the app build.
(ns granth-list.core)

(def granths ["Gita" "Kabir Sagar" "Ved"])

(defn -main []
  (doseq [[i g] (map-indexed vector granths)]
    (println (str (inc i) ". " g))))
;; Granth list sample — prints titles in order.
;; Granth list.
