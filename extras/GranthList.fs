// Standalone sample; not part of the app build.
module GranthList

let granths = [ "Gita"; "Kabir Sagar"; "Ved" ]

[<EntryPoint>]
let main _ =
    granths |> List.iteri (fun i g -> printfn "%d. %s" (i + 1) g)
    0
// Granth list sample — prints titles in order.
// Granth lis
