package logic

// Copyright (c) Microsoft and contributors.  All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//
// See the License for the specific language governing permissions and
// limitations under the License.
//
// Code generated by Microsoft (R) AutoRest Code Generator.
// Changes may cause incorrect behavior and will be lost if the code is regenerated.

import (
	"context"
	"github.com/Azure/go-autorest/autorest"
	"github.com/Azure/go-autorest/autorest/azure"
	"net/http"
)

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// IntegrationAccountAgreementsClient is the REST API for Azure Logic Apps.
type IntegrationAccountAgreementsClient struct {
	BaseClient
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// NewIntegrationAccountAgreementsClient creates an instance of the IntegrationAccountAgreementsClient client.
func NewIntegrationAccountAgreementsClient(subscriptionID string) IntegrationAccountAgreementsClient {
	return NewIntegrationAccountAgreementsClientWithBaseURI(DefaultBaseURI, subscriptionID)
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// NewIntegrationAccountAgreementsClientWithBaseURI creates an instance of the IntegrationAccountAgreementsClient
// client.
func NewIntegrationAccountAgreementsClientWithBaseURI(baseURI string, subscriptionID string) IntegrationAccountAgreementsClient {
	return IntegrationAccountAgreementsClient{NewWithBaseURI(baseURI, subscriptionID)}
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// CreateOrUpdate creates or updates an integration account agreement.
//
// resourceGroupName is the resource group name. integrationAccountName is the integration account name.
// agreementName is the integration account agreement name. agreement is the integration account agreement.
func (client IntegrationAccountAgreementsClient) CreateOrUpdate(ctx context.Context, resourceGroupName string, integrationAccountName string, agreementName string, agreement IntegrationAccountAgreement) (result IntegrationAccountAgreement, err error) {
	req, err := client.CreateOrUpdatePreparer(ctx, resourceGroupName, integrationAccountName, agreementName, agreement)
	if err != nil {
		err = autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "CreateOrUpdate", nil, "Failure preparing request")
		return
	}

	resp, err := client.CreateOrUpdateSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "CreateOrUpdate", resp, "Failure sending request")
		return
	}

	result, err = client.CreateOrUpdateResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "CreateOrUpdate", resp, "Failure responding to request")
	}

	return
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// CreateOrUpdatePreparer prepares the CreateOrUpdate request.
func (client IntegrationAccountAgreementsClient) CreateOrUpdatePreparer(ctx context.Context, resourceGroupName string, integrationAccountName string, agreementName string, agreement IntegrationAccountAgreement) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"agreementName":          autorest.Encode("path", agreementName),
		"integrationAccountName": autorest.Encode("path", integrationAccountName),
		"resourceGroupName":      autorest.Encode("path", resourceGroupName),
		"subscriptionId":         autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2015-08-01-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsContentType("application/json; charset=utf-8"),
		autorest.AsPut(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}", pathParameters),
		autorest.WithJSON(agreement),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// CreateOrUpdateSender sends the CreateOrUpdate request. The method will close the
// http.Response Body if it receives an error.
func (client IntegrationAccountAgreementsClient) CreateOrUpdateSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// CreateOrUpdateResponder handles the response to the CreateOrUpdate request. The method always
// closes the http.Response Body.
func (client IntegrationAccountAgreementsClient) CreateOrUpdateResponder(resp *http.Response) (result IntegrationAccountAgreement, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK, http.StatusCreated),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// Delete deletes an integration account agreement.
//
// resourceGroupName is the resource group name. integrationAccountName is the integration account name.
// agreementName is the integration account agreement name.
func (client IntegrationAccountAgreementsClient) Delete(ctx context.Context, resourceGroupName string, integrationAccountName string, agreementName string) (result autorest.Response, err error) {
	req, err := client.DeletePreparer(ctx, resourceGroupName, integrationAccountName, agreementName)
	if err != nil {
		err = autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "Delete", nil, "Failure preparing request")
		return
	}

	resp, err := client.DeleteSender(req)
	if err != nil {
		result.Response = resp
		err = autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "Delete", resp, "Failure sending request")
		return
	}

	result, err = client.DeleteResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "Delete", resp, "Failure responding to request")
	}

	return
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// DeletePreparer prepares the Delete request.
func (client IntegrationAccountAgreementsClient) DeletePreparer(ctx context.Context, resourceGroupName string, integrationAccountName string, agreementName string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"agreementName":          autorest.Encode("path", agreementName),
		"integrationAccountName": autorest.Encode("path", integrationAccountName),
		"resourceGroupName":      autorest.Encode("path", resourceGroupName),
		"subscriptionId":         autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2015-08-01-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsDelete(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// DeleteSender sends the Delete request. The method will close the
// http.Response Body if it receives an error.
func (client IntegrationAccountAgreementsClient) DeleteSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// DeleteResponder handles the response to the Delete request. The method always
// closes the http.Response Body.
func (client IntegrationAccountAgreementsClient) DeleteResponder(resp *http.Response) (result autorest.Response, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK, http.StatusNoContent),
		autorest.ByClosing())
	result.Response = resp
	return
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// Get gets an integration account agreement.
//
// resourceGroupName is the resource group name. integrationAccountName is the integration account name.
// agreementName is the integration account agreement name.
func (client IntegrationAccountAgreementsClient) Get(ctx context.Context, resourceGroupName string, integrationAccountName string, agreementName string) (result IntegrationAccountAgreement, err error) {
	req, err := client.GetPreparer(ctx, resourceGroupName, integrationAccountName, agreementName)
	if err != nil {
		err = autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "Get", nil, "Failure preparing request")
		return
	}

	resp, err := client.GetSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "Get", resp, "Failure sending request")
		return
	}

	result, err = client.GetResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "Get", resp, "Failure responding to request")
	}

	return
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// GetPreparer prepares the Get request.
func (client IntegrationAccountAgreementsClient) GetPreparer(ctx context.Context, resourceGroupName string, integrationAccountName string, agreementName string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"agreementName":          autorest.Encode("path", agreementName),
		"integrationAccountName": autorest.Encode("path", integrationAccountName),
		"resourceGroupName":      autorest.Encode("path", resourceGroupName),
		"subscriptionId":         autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2015-08-01-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsGet(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements/{agreementName}", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// GetSender sends the Get request. The method will close the
// http.Response Body if it receives an error.
func (client IntegrationAccountAgreementsClient) GetSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// GetResponder handles the response to the Get request. The method always
// closes the http.Response Body.
func (client IntegrationAccountAgreementsClient) GetResponder(resp *http.Response) (result IntegrationAccountAgreement, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// List gets a list of integration account agreements.
//
// resourceGroupName is the resource group name. integrationAccountName is the integration account name. top is the
// number of items to be included in the result. filter is the filter to apply on the operation.
func (client IntegrationAccountAgreementsClient) List(ctx context.Context, resourceGroupName string, integrationAccountName string, top *int32, filter string) (result IntegrationAccountAgreementListResultPage, err error) {
	result.fn = client.listNextResults
	req, err := client.ListPreparer(ctx, resourceGroupName, integrationAccountName, top, filter)
	if err != nil {
		err = autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "List", nil, "Failure preparing request")
		return
	}

	resp, err := client.ListSender(req)
	if err != nil {
		result.iaalr.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "List", resp, "Failure sending request")
		return
	}

	result.iaalr, err = client.ListResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "List", resp, "Failure responding to request")
	}

	return
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// ListPreparer prepares the List request.
func (client IntegrationAccountAgreementsClient) ListPreparer(ctx context.Context, resourceGroupName string, integrationAccountName string, top *int32, filter string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"integrationAccountName": autorest.Encode("path", integrationAccountName),
		"resourceGroupName":      autorest.Encode("path", resourceGroupName),
		"subscriptionId":         autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2015-08-01-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}
	if top != nil {
		queryParameters["$top"] = autorest.Encode("query", *top)
	}
	if len(filter) > 0 {
		queryParameters["$filter"] = autorest.Encode("query", filter)
	}

	preparer := autorest.CreatePreparer(
		autorest.AsGet(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Logic/integrationAccounts/{integrationAccountName}/agreements", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// ListSender sends the List request. The method will close the
// http.Response Body if it receives an error.
func (client IntegrationAccountAgreementsClient) ListSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// ListResponder handles the response to the List request. The method always
// closes the http.Response Body.
func (client IntegrationAccountAgreementsClient) ListResponder(resp *http.Response) (result IntegrationAccountAgreementListResult, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// listNextResults retrieves the next set of results, if any.
func (client IntegrationAccountAgreementsClient) listNextResults(lastResults IntegrationAccountAgreementListResult) (result IntegrationAccountAgreementListResult, err error) {
	req, err := lastResults.integrationAccountAgreementListResultPreparer()
	if err != nil {
		return result, autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "listNextResults", nil, "Failure preparing next results request")
	}
	if req == nil {
		return
	}
	resp, err := client.ListSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		return result, autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "listNextResults", resp, "Failure sending next results request")
	}
	result, err = client.ListResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "logic.IntegrationAccountAgreementsClient", "listNextResults", resp, "Failure responding to next results request")
	}
	return
}

// Deprecated: Please use package github.com/Azure/azure-sdk-for-go/services/preview/logic/mgmt/2015-08-01-preview/logic instead.
// ListComplete enumerates all values, automatically crossing page boundaries as required.
func (client IntegrationAccountAgreementsClient) ListComplete(ctx context.Context, resourceGroupName string, integrationAccountName string, top *int32, filter string) (result IntegrationAccountAgreementListResultIterator, err error) {
	result.page, err = client.List(ctx, resourceGroupName, integrationAccountName, top, filter)
	return
}
