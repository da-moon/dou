package requests

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/golang/protobuf/jsonpb"
	"github.com/sirupsen/logrus"
	df "google.golang.org/genproto/googleapis/cloud/dialogflow/v2"
)

// known intents
const (
	applications = "Applications"
	secrets      = "Secrets" // Intent Creation/Update/Delete
)

// ErrorInvalidInput basic errors
var ErrorInvalidInput = errors.New("Invalid hook request from webhook")

// ConsumeIntents default for proxy
func ConsumeIntents(c *gin.Context) {
	wr := df.WebhookRequest{}
	if err := jsonpb.Unmarshal(c.Request.Body, &wr); err != nil {
		logrus.WithError(err).Error(ErrorInvalidInput.Error())
		c.Status(http.StatusBadRequest)
		return
	}

	// What intent we are handling now is
	// The actions are the context those must be added as part of the
	// main activity
	switch wr.QueryResult.Intent.GetDisplayName() {
	case applications:
		logrus.Infoln("Incomming application requests")
		c.JSON(http.StatusOK, gin.H{})
	case secrets:
		logrus.Infoln("Accepted valued secrets")
		c.JSON(http.StatusOK, gin.H{})
	default:
		logrus.Errorln("Unknown action")
		c.AbortWithStatus(http.StatusNotFound)
	}
}

/*
// just tell me what I have access for
func listApplications(c *gin.Context, wr *df.WebhookRequest) {
	// hard coded just for the testing
	apps := []Application{Application{
		"vault",
	},
		Application{
			"consul",
		},
	}

	// back format in the response
	respose := &df.Fullfillment
}

// create the secret
func createSecret(c *gin.Context, wr *df.WebhookRequest) {}
*/
