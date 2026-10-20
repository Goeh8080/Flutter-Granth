(* Standalone sample; not part of the app build. *)
let granths = [ "Gita"; "Kabir Sagar"; "Ved" ]

let () = List.iteri (fun i g -> Printf.printf "%d. %s\n" (i + 1) g) granths
(* Granth list sample — prints titles in order. *)
(* Granth list sample Granth list sample Granth *)
