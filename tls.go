package main

import (
	"crypto/ecdsa"
	"crypto/elliptic"
	"crypto/rand"
	"crypto/tls"
	"crypto/x509"
	"crypto/x509/pkix"
	"fmt"
	"math"
	"math/big"
	"net"
	"strings"
	"time"
)

const certValidityDuration time.Duration = 24 * time.Hour * 7 // 7 days
var certValidityDurationDays int = int(math.Floor(certValidityDuration.Hours()) / 24)

// generateCert generates a self-signed certificate for the given and some default SANs.
// It's based on
// https://github.com/mholt/caddy/blob/master/caddytls/selfsigned.go and
// https://github.com/gerald1248/httpscerts/tree/diskless (which is based on
// https://github.com/kabukky/httpscerts, which is based on
// https://golang.org/src/crypto/tls/generate_cert.go).
func generateCert() (tls.Certificate, []string, error) {
	privKey, err := ecdsa.GenerateKey(elliptic.P256(), rand.Reader)
	if err != nil {
		return tls.Certificate{}, nil, fmt.Errorf("Failed to generate private key: %v", err)
	}

	notBefore := time.Now()
	notAfter := notBefore.Add(certValidityDuration)

	serialNumberLimit := new(big.Int).Lsh(big.NewInt(1), 128)
	serialNumber, err := rand.Int(rand.Reader, serialNumberLimit)
	if err != nil {
		return tls.Certificate{}, nil, fmt.Errorf("Failed to generate serial number: %v", err)
	}

	cert := x509.Certificate{
		SerialNumber: serialNumber,
		Subject:      pkix.Name{Organization: []string{"serve self-signed"}},
		NotBefore:    notBefore,
		NotAfter:     notAfter,
		KeyUsage:     x509.KeyUsageKeyEncipherment | x509.KeyUsageDigitalSignature,
		ExtKeyUsage:  []x509.ExtKeyUsage{x509.ExtKeyUsageServerAuth},
		// The certificate is used directly and not as CA to sign other certificates,
		// so we don't need `IsCA: true` or `KeyUsage |= x509.KeyUsageCertSign`.
	}

	// SAN = Subject Alternative Name / "subjectAltName".
	// The CN ("Common Name") seems to be deprecated in favor of SAN.
	// Usually used for hostname validation by clients.
	//
	// Note: Neither Firefox nor Chrome seem to validate the hostname for a self signed certificate
	// when its CA is not installed on the host. Instead they show the warning regarding the untrusted CA,
	// and when temporarily trusted within the browser no further warning is shown.
	// Microsoft Edge does it the other way around: When the hostname doesn't match a SAN entry it shows the appropriate warning,
	// but no warning regarding the untrusted CA. This is only shown when the hostname matches the SAN entry.
	//
	// However, in case the client installs the certificate on its host, or if some client does both checks,
	// having some SAN entries that might match the hostname might make sense.
	sans := defaultSANs()
	for _, san := range sans {
		if ip := net.ParseIP(san); ip != nil {
			cert.IPAddresses = append(cert.IPAddresses, ip)
		} else {
			cert.DNSNames = append(cert.DNSNames, strings.ToLower(san))
		}
	}

	derBytes, err := x509.CreateCertificate(rand.Reader, &cert, &cert, &privKey.PublicKey, privKey)
	if err != nil {
		return tls.Certificate{}, nil, fmt.Errorf("Could not create certificate: %v", err)
	}

	chain := [][]byte{derBytes}

	return tls.Certificate{
		Certificate: chain,
		PrivateKey:  privKey,
		Leaf:        &cert,
	}, sans, nil
}
