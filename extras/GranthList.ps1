# Standalone sample; not part of the app build.
$granths = @("Gita", "Kabir Sagar", "Ved")
for ($i = 0; $i -lt $granths.Count; $i++) {
    Write-Output "$($i + 1). $($granths[$i])"
}
# Granth list sample — prints titles in order.
# Granth list sample Granth list sample Granth.
