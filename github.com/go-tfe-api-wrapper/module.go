package main

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"

	"github.com/gorilla/mux"
)

type Module struct {
	ID          string `json:"id"`
	Name        string `json:"name"`
	Namespace   string `json:"namespace"`
	Provider    string `json:"provider"`
	Description string `json:"description"`
	Root        Root   `json:"root"`
}

type Root struct {
	Inputs  []Input  `json:"inputs"`
	Outputs []Output `json:"outputs"`
}

type Input struct {
	Name        string `json:"name"`
	Type        string `json:"type"`
	Description string `json:"description"`
	Default     string `json:"default"`
	Required    bool   `json:"required"`
}

type Output struct {
	Name        string `json:"name"`
	Description string `json:"description"`
}

func GetModuleHandler(w http.ResponseWriter, r *http.Request) {
	vars := mux.Vars(r)
	w.Header().Set("Content-Type", "application/json")

	if _, ok := vars["org"]; !ok {
		w.WriteHeader(http.StatusBadRequest)
		err := map[string]string{
			"error": "no org provided",
		}
		json.NewEncoder(w).Encode(err)

	}
	if _, ok := vars["module"]; !ok {
		w.WriteHeader(http.StatusBadRequest)
		err := map[string]string{
			"error": "no module provided",
		}
		json.NewEncoder(w).Encode(err)

	}
	if _, ok := vars["provider"]; !ok {
		w.WriteHeader(http.StatusBadRequest)
		err := map[string]string{
			"error": "no privider provided",
		}
		json.NewEncoder(w).Encode(err)

	}
	if _, ok := vars["version"]; !ok {
		w.WriteHeader(http.StatusBadRequest)
		err := map[string]string{
			"error": "no version provided",
		}
		json.NewEncoder(w).Encode(err)

	}

	client := &http.Client{}
	url := fmt.Sprintf("https://app.terraform.io/api/registry/v1/modules/%s/%s/%s/%s", vars["org"], vars["module"], vars["provider"], vars["version"])

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

	module := &Module{}

	err = json.NewDecoder(resp.Body).Decode(module)
	if err != nil {
		w.WriteHeader(http.StatusInternalServerError)
		errMessage := map[string]string{
			"error": err.Error(),
		}
		json.NewEncoder(w).Encode(errMessage)
	}

	json.NewEncoder(w).Encode(module)
}
