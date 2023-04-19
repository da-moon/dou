// Copyright 2021 Guillermo Estrada
//
// Package geohash provides encoding/decoding of base32 geohashes into coordinate pairs.
// From: https://en.wikipedia.org/wiki/Geohash
package geohash

import (
	"bytes"
	"math"
	"strings"
)

const (
	PIOVER180   = math.Pi / 180
	EARTHRADIUS = 6367444 // average on meters
)

var (
	// bounds uses the whole world as the default geohash region
	bounds = Region{
		Min: Location{-90.0, -180.0},
		Max: Location{90.0, 180.0},
	}

	//Base32 is the dictionary of characters for generating hashes
	base32 = []byte("0123456789bcdefghjkmnpqrstuvwxyz") /* cspell: disable-line */
	// Bitmask positions for 5 bit base32 encoding
	// []int{ 0b10000, 0b01000, 0b00100, 0b00010, 0b00001 }
	bits = []int{16, 8, 4, 2, 1}
)

// Location is a coordinate pair of latitude and longitude (y, x)
type Location struct {
	Latitude  float64 `json:"latitude"`
	Longitude float64 `json:"longitude"`
}

// Distance calculates the distance in meters between two
// locations using the Haversine formula.
func Distance(src, dst Location) float64 {
	u := Location{src.Latitude * PIOVER180, src.Longitude * PIOVER180}
	v := Location{dst.Latitude * PIOVER180, dst.Longitude * PIOVER180}
	// delta
	d := Location{u.Latitude - v.Latitude, u.Longitude - v.Longitude}
	a := math.Pow(math.Sin(d.Latitude/2), 2) + math.Cos(u.Latitude)*math.Cos(v.Latitude)*math.Pow(math.Sin(d.Longitude/2), 2)
	c := 2 * math.Atan2(math.Sqrt(a), math.Sqrt(1-a))
	return c * EARTHRADIUS
}

// Region is a bounding box representation of a given area
type Region struct {
	Min Location `json:"min"`
	Max Location `json:"max"`
}

// Center returns the mid point location of the region
func (r Region) Center() Location {
	return Location{
		Latitude:  (r.Min.Latitude + r.Max.Latitude) / 2,
		Longitude: (r.Min.Longitude + r.Max.Longitude) / 2,
	}
}

// Area calculates the approximated area of the region
// (width, height) using the haversine formula
func (r Region) Area() (float64, float64) {
	width := Distance(Location{r.Min.Latitude, r.Min.Longitude}, Location{r.Min.Latitude, r.Max.Longitude})
	height := Distance(Location{r.Min.Latitude, r.Min.Longitude}, Location{r.Max.Latitude, r.Min.Longitude})
	return width, height
}

// SetBounds changes the default bounding region for geohash calculations.
// Default is the world's default Latitude [-90.0, 90.0] and Longitude [-180.0, 180.0]
func SetBounds(minLatitude, minLongitude, maxLatitude, maxLongitude float64) {
	bounds = Region{
		Min: Location{minLatitude, minLongitude},
		Max: Location{maxLatitude, maxLongitude},
	}
}

// GetBounds returns the bounding region for geohash calculations.
// (MinLatitude, MinLongitude, MaxLatitude, MaxLongitude)
func GetBounds() (float64, float64, float64, float64) {
	return bounds.Min.Latitude, bounds.Min.Longitude, bounds.Max.Latitude, bounds.Max.Longitude
}

// Encode a latitude/longitude pair into a geohash with the given precision.
func Encode(latitude, longitude float64, precision int) string {
	minLatitude, minLongitude, maxLatitude, maxLongitude := GetBounds()
	latitude = fixOutOfBounds(latitude, minLatitude, maxLatitude)
	longitude = fixOutOfBounds(longitude, minLongitude, maxLongitude)
	char, bit := 0, 0
	even := true
	var geohash bytes.Buffer
	// Encode to the given precision
	for geohash.Len() < precision {
		if even { // LONGITUDE
			mid := (minLongitude + maxLongitude) / 2
			if longitude > mid { // EAST
				char |= bits[bit]
				minLongitude = mid
			} else { // WEST
				maxLongitude = mid
			}
		} else { // LATITUDE
			mid := (minLatitude + maxLatitude) / 2
			if latitude > mid { // NORTH
				char |= bits[bit]
				minLatitude = mid
			} else { //SOUTH
				maxLatitude = mid
			}
		}
		even = !even // toggle lat/lon

		// Every 5 bits, encode a character and reset
		if bit < 4 {
			bit++
		} else {
			geohash.WriteByte(base32[char])
			char, bit = 0, 0
		}
	}
	return geohash.String()
}

// Decode a geohash into a region
func Decode(geohash string) Region {
	geohash = strings.ToLower(geohash)
	minLatitude, minLongitude, maxLatitude, maxLongitude := GetBounds()
	// Even starts with longitude and toggles with each cycle
	even := true
	// Iterate over the geohash in byte form, c is each char/byte
	for _, char := range []byte(geohash) {
		// decimal will be the base32-unencoded integer value of char [0-31]
		decimal := bytes.IndexByte(base32, char)
		for i := 0; i < 5; i++ {
			mask := bits[i]
			if even { // longitude
				if decimal&mask != 0 {
					minLongitude = (minLongitude + maxLongitude) / 2 // EAST
				} else {
					maxLongitude = (minLongitude + maxLongitude) / 2 // WEST
				}
			} else { // latitude
				if decimal&mask != 0 {
					minLatitude = (minLatitude + maxLatitude) / 2 // NORTH
				} else {
					maxLatitude = (minLatitude + maxLatitude) / 2 // SOUTH
				}
			}
			even = !even // toggle lat/lon
		}
	}
	return Region{Location{minLatitude, minLongitude}, Location{maxLatitude, maxLongitude}}
}

// Neighbours calculates the 8 adjacent neighboring geohashes with the same precision
func Neighbours(geohash string) map[string]string {
	region := Decode(geohash)
	/// width and height are deltas for calculating the neighbours
	width := math.Abs(region.Max.Longitude - region.Min.Longitude)
	height := math.Abs(region.Max.Latitude - region.Min.Latitude)
	latitude := region.Center().Latitude
	longitude := region.Center().Longitude
	precision := len(geohash)
	// return a map with the 8 adjacent neighbours
	return map[string]string{
		"n":  Encode(latitude+height, longitude, precision),
		"s":  Encode(latitude-height, longitude, precision),
		"e":  Encode(latitude, longitude+width, precision),
		"w":  Encode(latitude, longitude-width, precision),
		"ne": Encode(latitude+height, longitude+width, precision),
		"se": Encode(latitude-height, longitude+width, precision),
		"sw": Encode(latitude-height, longitude-width, precision),
		"nw": Encode(latitude+height, longitude-width, precision),
	}
}

// Valid checks if all the characters in a geohash are valid base32/geohash characters
func Valid(geohash string) bool {
	geohash = strings.ToLower(geohash)
	if len(geohash) < 1 {
		return false
	}
	for _, c := range []byte(geohash) {
		if i := bytes.IndexByte(base32, c); i == -1 {
			return false
		}
	}
	return true
}

// Rotates the map for out of bound coordinates
func fixOutOfBounds(num, min, max float64) float64 {
	if num < min {
		return max + (num - min)
	}
	if num > max {
		return min + (num - max)
	}
	return num
}
