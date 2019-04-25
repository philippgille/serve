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
	"crypto/tls"
	"flag"
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
	"runtime"
	"strings"
)

// Increment and remove "+" in release commits.
// Add "+" after release commits.
const version = "v0.2.1"

// Flags in alphabetical order, just like "-h" prints them
var (
	auth         = flag.String("a", "", `Require basic authentication with the given credentials (e.g. -a "alice:secret")`)
	directory    = flag.String("d", ".", "The directory of static file to host")
	help         = flag.Bool("h", false, "Print the usage")
	port         = flag.String("p", "8100", "Port to serve on")
	https        = flag.Bool("s", false, "Serve via HTTPS instead of HTTP. Creates a temporary self-signed certificate for localhost, 127.0.0.1, <hostname>.local, <hostname>.lan, <hostname>.home and the determined LAN IP address")
	test         = flag.Bool("t", false, "Test / dry run (just prints the interface table)")
	printVersion = flag.Bool("v", false, "Print the version")
)

func main() {
	flag.Parse()

	// If the "-h" flag was used, only print the usage and exit.
	// Without the "-h" flag in the flag definitions "-h" would also print the usage,
	// but only because it's an unknown flag and then exit with exit code 2 (instead of 0).
	if *help {
		// flag.Usage() prints to stderr by default because it's usually called internally
		// (in the flag package) when an invalid argument is used.
		// But in our case it's meant to be printed, so print to stdout.
		flag.CommandLine.SetOutput(os.Stdout)
		flag.Usage()
		os.Exit(0)
	}

	// If the "-t" flag was used, only print the network interface table and exit
	if *test {
		printAddrs(*port, *https)
		os.Exit(0)
	}

	// If the "-v" flag was used, only print the version and exit
	if *printVersion {
		fmt.Printf("serve version: %v\n", version)
		os.Exit(0)
	}

	finalHandler := http.FileServer(http.Dir(*directory))

	// If the "-a" flag was used, use basic authentication middleware
	if *auth != "" {
		if !strings.Contains(*auth, ":") {
			log.Fatal(`When using the -a flag to add basic authentication, you must specify credentials in the form of "username:password". For example: "alice:secret".`)
		}
		finalHandler = withBasicAuth(finalHandler)
	}

	// Register handler for "/" in Go's DefaultServeMux
	http.Handle("/", finalHandler)

	scheme := "HTTP"
	if *https {
		scheme += "S"
	}
	fmt.Printf("\nServing \"%s\" on all network interfaces (0.0.0.0) on %v port: %s\n", *directory, scheme, *port)

	// Print local network interfaces and their IP addresses
	printAddrs(*port, *https)

	if *https {
		cert, sans, err := generateCert()
		if err != nil {
			log.Fatalf("Couldn't generate TLS certificates: %v\n", err)
		}
		tlsConfig := &tls.Config{
			MinVersion:               tls.VersionTLS12,
			PreferServerCipherSuites: true,
			Certificates:             []tls.Certificate{cert},
		}
		server := &http.Server{
			Addr:      ":" + *port,
			TLSConfig: tlsConfig,
		}
		fmt.Printf("\nTemporary self signed certificate valid for %v days for the following hostnames: %v\n", certValidityDurationDays, sans)
		// TODO: Print the certificate fingerprint so the server can send it to the client via a secure channel
		// and the client can then validate it to make sure it's not a different certificate created by a malicious actor (MitM).
		// But first do some research regarding if the fingerprint is sufficient for that.
		// Also the fingerprint should probably be a different one with each certificate generation,
		// which didn't seem to be the case during my trials, but maybe I generated the fingerprint in the wrong way.
		log.Fatal(server.ListenAndServeTLS("", ""))
	} else {

		log.Fatal(http.ListenAndServe(":"+*port, nil))
	}
}

// printAddrs prints the local network interfaces and their IP addresses
func printAddrs(port string, https bool) {
	fmt.Println("\nLocal network interfaces and their IP addresses so you can pass one to your colleagues:")
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
		scheme := "http"
		if https {
			scheme += "s"
		}
		fmt.Printf("\nYou probably want to share:\n%v://%v:%v\n", scheme, fav, port)
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

// isFav checks the network interface's name and if it's a typical main one (like "eth0" on Linux) it returns true.
//
// Note: All possible runtime.GOOS values are listed here: https://golang.org/doc/install/source#environment
func isFav(iface net.Interface) bool {
	switch runtime.GOOS {
	case "windows":
		if iface.Name == "WiFi" ||
			len(iface.Name) >= 8 && iface.Name[:8] == "Ethernet" {
			return true
		}
	case "darwin":
		if iface.Name == "en0" || iface.Name == "en1" {
			return true
		}
	case "linux":
		if iface.Name == "eth0" || iface.Name == "wlan0" {
			return true
		}
	}
	return false
}

// withBasicAuth adds a basic authentication middleware before the passed handler.
func withBasicAuth(next http.Handler) http.Handler {
	return http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		username, password, ok := r.BasicAuth()
		if !ok {
			w.Header().Set("WWW-Authenticate", "Basic")
			w.WriteHeader(http.StatusUnauthorized)
			return
		}
		if username+":"+password != *auth {
			w.WriteHeader(http.StatusForbidden)
			return
		}
		next.ServeHTTP(w, r)
	})
}
