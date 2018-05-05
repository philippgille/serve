/*
Serve starts a simple temporary static file server in your current directory and prints your IP address to share with colleagues.

Based on the Gist https://gist.github.com/paulmach/7271283/2a1116ca15e34ee23ac5a3a87e2a626451424993
by Paul Mach (https://github.com/paulmach)

Usage:
  -d string
        The directory of static file to host (default ".")
  -p string
        Port to serve on (default "8100")
  -t    Test / dry run (just prints the interface table)
  -v    Print the version

Navigating to http://localhost:8100 will display the index.html or directory listing file.
*/
package main

import (
	"flag"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"strings"
)

// Increment and remove "+" in release commits.
// Add "+" after release commits.
const version = "v0.2.0"

// Flags in alphabetical order, just like "-h" prints them
var (
	directory    = flag.String("d", ".", "The directory of static file to host")
	port         = flag.String("p", "8100", "Port to serve on")
	test         = flag.Bool("t", false, "Test / dry run (just prints the interface table)")
	printVersion = flag.Bool("v", false, "Print the version")
)

func main() {
	flag.Parse()

	// If the "v" flag was used, only print the version and exit
	if *printVersion {
		fmt.Printf("serve version: %v\n", version)
		os.Exit(0)
	}

	// If the "t" flag was used, only print the network interface table and exit
	if *test {
		printAddrs(*port)
		os.Exit(0)
	}

	// Register handler for "/" in Go's DefaultServeMux
	http.Handle("/", http.FileServer(http.Dir(*directory)))

	fmt.Printf("\nServing \"%s\" on all network interfaces (0.0.0.0) on HTTP port: %s\n", *directory, *port)

	// Print local network interfaces and their IP addresses
	printAddrs(*port)

	log.Fatal(http.ListenAndServe(":"+*port, nil))
}

// printAddrs prints the local network interfaces and their IP addresses
func printAddrs(port string) {
	fmt.Println("\nLocal network interfaces and their IP addresses so you can pass one to your colleagues:\n")
	ifaces, err := net.Interfaces()
	if err != nil {
		log.Fatal(err)
	}
	// We want the interface + IP address list to look like a table with a width of 80:
	//       Interface      |  IPv4 Address   |              IPv6 Address
	// ---------------------|-----------------|----------------------------------------
	// vEthernet (Standan.. | 192.168.178.123 | 1a23:850a:bf55:39a9:6dae:c378:9deb:5aff
	fmt.Println("      Interface      |  IPv4 Address   |              IPv6 Address              ")
	fmt.Println("---------------------|-----------------|----------------------------------------")
	fav := ""
	for _, iface := range ifaces {
		fmt.Printf("%-20v |", cutString(iface.Name, 20))

		// Select IPv4 and IPv6 address
		ipv4, ipv6 := getAddressesFromIface(iface)

		// If there's no favorite IPv4 address yet, check if we should pick the current one
		if fav == "" && isFav(iface) {
			fav = ipv4
		}

		fmt.Printf(" %-15v | %v\n", ipv4, ipv6)
	}

	// Show probable favorite
	if fav != "" {
		fmt.Printf("\nYou probably want to share:\nhttp://%v:%v\n", fav, port)
	}
}

// cutString cuts strings that exceed the maxLen to (maxLen-2) and adds ".."
func cutString(s string, maxLen int) string {
	if len(s) > maxLen {
		return s[:maxLen-2] + ".."
	}
	return s
}

// getAddressesFromIface goes through the addresses of the given interface and tries to return the first of each kind.
//
// The interesting interfaces like eth0 and wlan0 typically have 2 addresses: one IPv4 and one IPv6 address.
// But some interfaces just have one of them, or if an interface is deactivated it doesn't have any.
// On Windows the main network interface like "Ethernet 3" can have many addresses and the main IPv4 address doesn't have to be one of the first 2.
// We must take care of all these combinations.
func getAddressesFromIface(iface net.Interface) (ipv4 string, ipv6 string) {
	addrs, err := iface.Addrs()
	if err != nil {
		log.Fatal(err)
	}
	for i := 0; i < len(addrs) && (ipv4 == "" || ipv6 == ""); i++ {
		// In the case of two addresses they could potentially be of the same type.
		// We want to show the first address. overwriteIfEmpty() doesn't overwrite existing values.
		addrWithoutMask := strings.Split(addrs[i].String(), "/")[0]
		if strings.Contains(addrWithoutMask, ":") {
			overwriteIfEmpty(&ipv4, "")
			overwriteIfEmpty(&ipv6, addrWithoutMask)
		} else {
			overwriteIfEmpty(&ipv4, addrWithoutMask)
			overwriteIfEmpty(&ipv6, "")
		}
	}
	return
}

// overwriteIfEmpty only overwrites the string s with the string overwrite if s is empty
func overwriteIfEmpty(s *string, overwrite string) {
	if *s == "" {
		*s = overwrite
	}
}

// isFav checks the network interface's name and if it's a typical main one (like "eth0") it returns true.
func isFav(iface net.Interface) bool {
	if iface.Name == "eth0" ||
		iface.Name == "wlan0" ||
		len(iface.Name) >= 8 && iface.Name[:8] == "Ethernet" {
		return true
	}
	return false
}
