package main

import "flag"

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
