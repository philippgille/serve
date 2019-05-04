package main

import (
	"flag"
	"log"
	"os"
)

// cutString cuts strings that exceed the maxLen to (maxLen-2) and adds ".."
func cutString(s string, maxLen int) string {
	if len(s) > maxLen {
		return s[:maxLen-2] + ".."
	}
	return s
}

// overwriteIfEmpty only overwrites the string s with the string overwrite if s is empty
func overwriteIfEmpty(s *string, overwrite string) {
	if *s == "" {
		*s = overwrite
	}
}

// isFlagPassed returns true if the flag was explicitly set as CLI parameter
func isFlagPassed(name string) bool {
	found := false
	flag.Visit(func(f *flag.Flag) {
		if f.Name == name {
			found = true
		}
	})
	return found
}

// isDirAccessible checks if the directory exsists, if it really is a directory instead of a file and if it's readable.
// If logFatal is true, errors will be printed and the program will exit. If it's false the program will just return the result.
func isDirAccessible(dir string, logFatal bool) bool {
	// Use Stat instead of Lstat because serving works with softlinks (e.g. "serve -d ./softlink")
	fileInfo, err := os.Stat(*directory)
	if err != nil {
		if logFatal {
			log.Fatalf("%v can't be served: %v\n", *directory, err)
		}
		return false
	} else if !fileInfo.IsDir() {
		if logFatal {
			log.Fatalf("%v can't be served because it's a file and not a directory: %v\n", *directory, err)
		}
		return false
	} else {
		file, err := os.Open(*directory)
		if err != nil {
			if logFatal {
				log.Fatalf("%v can't be served because it's not readable: %v\n", *directory, err)
			}
			return false
		} else {
			file.Close() // Ignore errors
		}
	}
	return true
}
