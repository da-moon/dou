package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"

	"github.com/gorilla/mux"
)

type Modules struct {
	Data  []Data `json:"data"`
	Links Links  `json:"links"`
}

type Links struct {
	Self string `json:"self"`
	Next string `json:"next"`
}

type Data struct {
	ID         string     `json:"id"`
	Type       string     `json:"type"`
	Attributes Attributes `json:"attributes"`
}

type Attributes struct {
	Name          string          `json:"name"`
	Namespace     string          `json:"namespace"`
	Provider      string          `json:"provider"`
	Status        string          `json:"status"`
	VersionStatus []VersionStatus `json:"version-statuses"`
	CreatedAt     string          `json:"created-at"`
	UpdatedAt     string          `json:"updated-at"`
	RegistryName  string          `json:"registry-name"`
	VCSRepo       VCSRepo         `json:"vcs-repo"`
}

type VersionStatus struct {
	Version string `json:"version"`
	Status  string `json:"status"`
}

type VCSRepo struct {
	Branch            string `json:"branch"`
	IngressSubmodules bool   `json:"ingress-submodules"`
	Identifier        string `json:"identifier"`
	DisplayIdentifier string `json:"display-identifier"`
	RepositoryHTTPURL string `json:"respository-http-url"`
	ServiceProvider   string `json:"service-provider"`
}

func GetModulesHandler(w http.ResponseWriter, r *http.Request) {

	vars := mux.Vars(r)
	w.Header().Set("Content-Type", "application/json")

	if _, ok := vars["org"]; !ok {
		w.WriteHeader(http.StatusBadRequest)
		err := map[string]string{
			"error": "no org provided",
		}
		json.NewEncoder(w).Encode(err)

	}

	client := &http.Client{}
	next := true
	url := fmt.Sprintf("https://app.terraform.io/api/v2/organizations/%s/registry-modules", vars["org"])
	result := []Data{}
	for next {
		request, err := http.NewRequest(http.MethodGet, url, nil)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			errMessage := map[string]string{
				"error": err.Error(),
			}
			json.NewEncoder(w).Encode(errMessage)
		}
		request.Header.Add("Authorization", token)

		resp, err := client.Do(request)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			errMessage := map[string]string{
				"error": err.Error(),
			}
			json.NewEncoder(w).Encode(errMessage)
		}

		defer resp.Body.Close()

		if resp.StatusCode != http.StatusOK {
			b, err := io.ReadAll(resp.Body)
			if err != nil {
				w.WriteHeader(http.StatusInternalServerError)
				errMessage := map[string]string{
					"error": err.Error(),
				}
				json.NewEncoder(w).Encode(errMessage)
			}
			fmt.Fprint(w, string(b))
		}

		data := &Modules{}

		err = json.NewDecoder(resp.Body).Decode(data)
		if err != nil {
			w.WriteHeader(http.StatusInternalServerError)
			errMessage := map[string]string{
				"error": err.Error(),
			}
			json.NewEncoder(w).Encode(errMessage)
		}

		result = append(result, data.Data...)

		next = len(data.Links.Next) > 0
		url = data.Links.Next

	}

	response := &Modules{Data: result}
	json.NewEncoder(w).Encode(response)

}
