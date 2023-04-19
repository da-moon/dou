package main

import (
	"os"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"

	"github.com/DigitalOnUs/vbot/requests"
)

var (
	addresss = "8080"
)

func main() {
	r := gin.Default()

	// routes (default answers)
	r.POST("/consume", requests.ConsumeIntents)

	if err := r.Run(":" + addresss); err != nil {
		logrus.WithError(err).Fatal("cannot start server")
	}
}

func init() {
	if val := os.Getenv("PORT"); val != "" {
		addresss = val
	}
}
