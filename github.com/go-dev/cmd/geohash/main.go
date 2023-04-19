package main

import (
	"embed"
	"io/fs"
	"log"
	"net/http"
	"os"
	"path"
	"strconv"

	"github.com/DigitalOnUs/go-dev/pkg/geohash"
	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/favicon"
	"github.com/gofiber/fiber/v2/middleware/filesystem"
	"github.com/gofiber/fiber/v2/middleware/logger"
	"github.com/gofiber/fiber/v2/middleware/recover"
	"github.com/gofiber/fiber/v2/middleware/requestid"
)

const (
	maxPrecision = 13
)

//go:embed static
var static embed.FS

// GeohashResponseV1 represents a complete geohash
// encoding/decoding response for v1 of the api
type GeohashResponseV1 struct {
	Geohash    string            `json:"geohash"`
	Precision  int               `json:"precision"`
	Region     geohash.Region    `json:"region"`
	Center     geohash.Location  `json:"center"`
	Width      float64           `json:"width"`
	Height     float64           `json:"height"`
	Neighbours map[string]string `json:"neighbours"`
}

func NewGeohashResponseV1(hash string) GeohashResponseV1 {
	region := geohash.Decode(hash)
	width, height := region.Area()
	return GeohashResponseV1{
		Geohash:    hash,
		Precision:  len(hash),
		Region:     region,
		Center:     region.Center(),
		Width:      width,
		Height:     height,
		Neighbours: geohash.Neighbours(hash),
	}
}

func encode(c *fiber.Ctx) error {
	latitude, err := strconv.ParseFloat(c.Params("latitude"), 64)
	if err != nil || latitude < -90 || latitude > 90 {
		return fiber.ErrBadRequest
	}
	longitude, err := strconv.ParseFloat(c.Params("longitude"), 64)
	if err != nil || longitude < -180 || longitude > 180 {
		return fiber.ErrBadRequest
	}
	precision, err := strconv.ParseInt(c.Query("precision"), 10, 8)
	if err != nil || precision <= 0 || precision > maxPrecision {
		precision = maxPrecision
	}
	hash := geohash.Encode(latitude, longitude, int(precision))
	return c.JSON(NewGeohashResponseV1(hash))
}

func decode(c *fiber.Ctx) error {
	hash := c.Params("geohash")
	if !geohash.Valid(hash) {
		return fiber.ErrBadRequest
	}
	if len(hash) > maxPrecision {
		hash = hash[0:maxPrecision]
	}
	return c.JSON(NewGeohashResponseV1(hash))
}

func main() {
	app := fiber.New()
	app.Use(recover.New())
	app.Use(favicon.New(favicon.Config{
		File: "./static/favicon.ico",
	}))
	app.Use(logger.New())

	api := app.Group("/api", requestid.New())
	v1 := api.Group("/v1")
	v1.Get("/encode/:latitude/:longitude", encode)
	v1.Get("/decode/:geohash", decode)

	app.Use("/", filesystem.New(filesystem.Config{
		Root: NewPrefixedFS("static", static),
	}))

	log.Fatal(app.Listen(":" + os.Getenv("PORT")))
}

// ----------------------------------------------------------------
// CODE TO BE REMOVED AFTER FIBER VERSION UPGRADE
// ----------------------------------------------------------------

// PrefixedFS temporal solution until fixed for go 1.16
// https://github.com/gofiber/fiber/issues/1308
type PrefixedFS struct {
	Prefix string
	FS     http.FileSystem
}

// NewPrefixedFS creates an embedded FS that strips the prefix from the path
func NewPrefixedFS(prefix string, filesystem fs.FS) *PrefixedFS {
	return &PrefixedFS{
		Prefix: prefix,
		FS:     http.FS(filesystem),
	}
}

// Open overwrites the default method for the fs.FS interface
func (fs *PrefixedFS) Open(name string) (http.File, error) {
	name = path.Clean("/" + fs.Prefix + "/" + name)
	return fs.FS.Open(name)
}
