// Standalone sample; not part of the app build.
package main

import "fmt"

func main() {
	granths := []string{"गीता", "कबीर सागर", "वेद"}
	for i, g := range granths {
		fmt.Printf("%d. %s\n", i+1, g)
	}
}
// Granth list sample Granth list sample G
