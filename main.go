package main

import (
	"fmt"
	"log"
	"net/http"
	"os"

	"github.com/gorilla/mux"
	"github.com/rs/cors"
)

var token string = fmt.Sprintf("Bearer %s", os.Getenv("AUTH_TOKEN"))

func main() {

	router := mux.NewRouter()
	router.HandleFunc("/organization/{org}", GetModulesHandler).Methods("GET")
	router.HandleFunc("/organization/{org}/{module}/{provider}/{version}", GetModuleHandler).Methods("GET")

	handler := cors.Default().Handler(router)
	log.Fatal(http.ListenAndServe(":8000", handler))
}
