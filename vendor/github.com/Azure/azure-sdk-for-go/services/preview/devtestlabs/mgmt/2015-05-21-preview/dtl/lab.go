package dtl

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

// LabClient is the azure DevTest Labs REST API version 2015-05-21-preview.
type LabClient struct {
	BaseClient
}

// NewLabClient creates an instance of the LabClient client.
func NewLabClient(subscriptionID string) LabClient {
	return NewLabClientWithBaseURI(DefaultBaseURI, subscriptionID)
}

// NewLabClientWithBaseURI creates an instance of the LabClient client.
func NewLabClientWithBaseURI(baseURI string, subscriptionID string) LabClient {
	return LabClient{NewWithBaseURI(baseURI, subscriptionID)}
}

// CreateEnvironment create virtual machines in a Lab. This operation can take a while to complete.
// Parameters:
// resourceGroupName - the name of the resource group.
// name - the name of the lab.
func (client LabClient) CreateEnvironment(ctx context.Context, resourceGroupName string, name string, labVirtualMachine LabVirtualMachine) (result LabCreateEnvironmentFuture, err error) {
	req, err := client.CreateEnvironmentPreparer(ctx, resourceGroupName, name, labVirtualMachine)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "CreateEnvironment", nil, "Failure preparing request")
		return
	}

	result, err = client.CreateEnvironmentSender(req)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "CreateEnvironment", result.Response(), "Failure sending request")
		return
	}

	return
}

// CreateEnvironmentPreparer prepares the CreateEnvironment request.
func (client LabClient) CreateEnvironmentPreparer(ctx context.Context, resourceGroupName string, name string, labVirtualMachine LabVirtualMachine) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"name":              autorest.Encode("path", name),
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2015-05-21-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsContentType("application/json; charset=utf-8"),
		autorest.AsPost(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/createEnvironment", pathParameters),
		autorest.WithJSON(labVirtualMachine),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// CreateEnvironmentSender sends the CreateEnvironment request. The method will close the
// http.Response Body if it receives an error.
func (client LabClient) CreateEnvironmentSender(req *http.Request) (future LabCreateEnvironmentFuture, err error) {
	var resp *http.Response
	resp, err = autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
	if err != nil {
		return
	}
	err = autorest.Respond(resp, azure.WithErrorUnlessStatusCode(http.StatusOK, http.StatusAccepted))
	if err != nil {
		return
	}
	future.Future, err = azure.NewFutureFromResponse(resp)
	return
}

// CreateEnvironmentResponder handles the response to the CreateEnvironment request. The method always
// closes the http.Response Body.
func (client LabClient) CreateEnvironmentResponder(resp *http.Response) (result autorest.Response, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK, http.StatusAccepted),
		autorest.ByClosing())
	result.Response = resp
	return
}

// CreateOrUpdateResource create or replace an existing Lab. This operation can take a while to complete.
// Parameters:
// resourceGroupName - the name of the resource group.
// name - the name of the lab.
func (client LabClient) CreateOrUpdateResource(ctx context.Context, resourceGroupName string, name string, lab Lab) (result LabCreateOrUpdateResourceFuture, err error) {
	req, err := client.CreateOrUpdateResourcePreparer(ctx, resourceGroupName, name, lab)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "CreateOrUpdateResource", nil, "Failure preparing request")
		return
	}

	result, err = client.CreateOrUpdateResourceSender(req)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "CreateOrUpdateResource", result.Response(), "Failure sending request")
		return
	}

	return
}

// CreateOrUpdateResourcePreparer prepares the CreateOrUpdateResource request.
func (client LabClient) CreateOrUpdateResourcePreparer(ctx context.Context, resourceGroupName string, name string, lab Lab) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"name":              autorest.Encode("path", name),
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2015-05-21-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsContentType("application/json; charset=utf-8"),
		autorest.AsPut(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}", pathParameters),
		autorest.WithJSON(lab),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// CreateOrUpdateResourceSender sends the CreateOrUpdateResource request. The method will close the
// http.Response Body if it receives an error.
func (client LabClient) CreateOrUpdateResourceSender(req *http.Request) (future LabCreateOrUpdateResourceFuture, err error) {
	var resp *http.Response
	resp, err = autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
	if err != nil {
		return
	}
	err = autorest.Respond(resp, azure.WithErrorUnlessStatusCode(http.StatusOK, http.StatusCreated))
	if err != nil {
		return
	}
	future.Future, err = azure.NewFutureFromResponse(resp)
	return
}

// CreateOrUpdateResourceResponder handles the response to the CreateOrUpdateResource request. The method always
// closes the http.Response Body.
func (client LabClient) CreateOrUpdateResourceResponder(resp *http.Response) (result Lab, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK, http.StatusCreated),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// DeleteResource delete lab. This operation can take a while to complete.
// Parameters:
// resourceGroupName - the name of the resource group.
// name - the name of the lab.
func (client LabClient) DeleteResource(ctx context.Context, resourceGroupName string, name string) (result LabDeleteResourceFuture, err error) {
	req, err := client.DeleteResourcePreparer(ctx, resourceGroupName, name)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "DeleteResource", nil, "Failure preparing request")
		return
	}

	result, err = client.DeleteResourceSender(req)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "DeleteResource", result.Response(), "Failure sending request")
		return
	}

	return
}

// DeleteResourcePreparer prepares the DeleteResource request.
func (client LabClient) DeleteResourcePreparer(ctx context.Context, resourceGroupName string, name string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"name":              autorest.Encode("path", name),
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2015-05-21-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsDelete(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// DeleteResourceSender sends the DeleteResource request. The method will close the
// http.Response Body if it receives an error.
func (client LabClient) DeleteResourceSender(req *http.Request) (future LabDeleteResourceFuture, err error) {
	var resp *http.Response
	resp, err = autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
	if err != nil {
		return
	}
	err = autorest.Respond(resp, azure.WithErrorUnlessStatusCode(http.StatusOK, http.StatusAccepted, http.StatusNoContent))
	if err != nil {
		return
	}
	future.Future, err = azure.NewFutureFromResponse(resp)
	return
}

// DeleteResourceResponder handles the response to the DeleteResource request. The method always
// closes the http.Response Body.
func (client LabClient) DeleteResourceResponder(resp *http.Response) (result autorest.Response, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK, http.StatusAccepted, http.StatusNoContent),
		autorest.ByClosing())
	result.Response = resp
	return
}

// GenerateUploadURI generate a URI for uploading custom disk images to a Lab.
// Parameters:
// resourceGroupName - the name of the resource group.
// name - the name of the lab.
func (client LabClient) GenerateUploadURI(ctx context.Context, resourceGroupName string, name string, generateUploadURIParameter GenerateUploadURIParameter) (result GenerateUploadURIResponse, err error) {
	req, err := client.GenerateUploadURIPreparer(ctx, resourceGroupName, name, generateUploadURIParameter)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "GenerateUploadURI", nil, "Failure preparing request")
		return
	}

	resp, err := client.GenerateUploadURISender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "GenerateUploadURI", resp, "Failure sending request")
		return
	}

	result, err = client.GenerateUploadURIResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "GenerateUploadURI", resp, "Failure responding to request")
	}

	return
}

// GenerateUploadURIPreparer prepares the GenerateUploadURI request.
func (client LabClient) GenerateUploadURIPreparer(ctx context.Context, resourceGroupName string, name string, generateUploadURIParameter GenerateUploadURIParameter) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"name":              autorest.Encode("path", name),
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2015-05-21-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsContentType("application/json; charset=utf-8"),
		autorest.AsPost(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/generateUploadUri", pathParameters),
		autorest.WithJSON(generateUploadURIParameter),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// GenerateUploadURISender sends the GenerateUploadURI request. The method will close the
// http.Response Body if it receives an error.
func (client LabClient) GenerateUploadURISender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// GenerateUploadURIResponder handles the response to the GenerateUploadURI request. The method always
// closes the http.Response Body.
func (client LabClient) GenerateUploadURIResponder(resp *http.Response) (result GenerateUploadURIResponse, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// GetResource get lab.
// Parameters:
// resourceGroupName - the name of the resource group.
// name - the name of the lab.
func (client LabClient) GetResource(ctx context.Context, resourceGroupName string, name string) (result Lab, err error) {
	req, err := client.GetResourcePreparer(ctx, resourceGroupName, name)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "GetResource", nil, "Failure preparing request")
		return
	}

	resp, err := client.GetResourceSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "GetResource", resp, "Failure sending request")
		return
	}

	result, err = client.GetResourceResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "GetResource", resp, "Failure responding to request")
	}

	return
}

// GetResourcePreparer prepares the GetResource request.
func (client LabClient) GetResourcePreparer(ctx context.Context, resourceGroupName string, name string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"name":              autorest.Encode("path", name),
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2015-05-21-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsGet(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// GetResourceSender sends the GetResource request. The method will close the
// http.Response Body if it receives an error.
func (client LabClient) GetResourceSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// GetResourceResponder handles the response to the GetResource request. The method always
// closes the http.Response Body.
func (client LabClient) GetResourceResponder(resp *http.Response) (result Lab, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// ListByResourceGroup list labs.
// Parameters:
// resourceGroupName - the name of the resource group.
// filter - the filter to apply on the operation.
func (client LabClient) ListByResourceGroup(ctx context.Context, resourceGroupName string, filter string, top *int32, orderBy string) (result ResponseWithContinuationLabPage, err error) {
	result.fn = client.listByResourceGroupNextResults
	req, err := client.ListByResourceGroupPreparer(ctx, resourceGroupName, filter, top, orderBy)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "ListByResourceGroup", nil, "Failure preparing request")
		return
	}

	resp, err := client.ListByResourceGroupSender(req)
	if err != nil {
		result.rwcl.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "ListByResourceGroup", resp, "Failure sending request")
		return
	}

	result.rwcl, err = client.ListByResourceGroupResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "ListByResourceGroup", resp, "Failure responding to request")
	}

	return
}

// ListByResourceGroupPreparer prepares the ListByResourceGroup request.
func (client LabClient) ListByResourceGroupPreparer(ctx context.Context, resourceGroupName string, filter string, top *int32, orderBy string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2015-05-21-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}
	if len(filter) > 0 {
		queryParameters["$filter"] = autorest.Encode("query", filter)
	}
	if top != nil {
		queryParameters["$top"] = autorest.Encode("query", *top)
	}
	if len(orderBy) > 0 {
		queryParameters["$orderBy"] = autorest.Encode("query", orderBy)
	}

	preparer := autorest.CreatePreparer(
		autorest.AsGet(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// ListByResourceGroupSender sends the ListByResourceGroup request. The method will close the
// http.Response Body if it receives an error.
func (client LabClient) ListByResourceGroupSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// ListByResourceGroupResponder handles the response to the ListByResourceGroup request. The method always
// closes the http.Response Body.
func (client LabClient) ListByResourceGroupResponder(resp *http.Response) (result ResponseWithContinuationLab, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// listByResourceGroupNextResults retrieves the next set of results, if any.
func (client LabClient) listByResourceGroupNextResults(lastResults ResponseWithContinuationLab) (result ResponseWithContinuationLab, err error) {
	req, err := lastResults.responseWithContinuationLabPreparer()
	if err != nil {
		return result, autorest.NewErrorWithError(err, "dtl.LabClient", "listByResourceGroupNextResults", nil, "Failure preparing next results request")
	}
	if req == nil {
		return
	}
	resp, err := client.ListByResourceGroupSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		return result, autorest.NewErrorWithError(err, "dtl.LabClient", "listByResourceGroupNextResults", resp, "Failure sending next results request")
	}
	result, err = client.ListByResourceGroupResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "listByResourceGroupNextResults", resp, "Failure responding to next results request")
	}
	return
}

// ListByResourceGroupComplete enumerates all values, automatically crossing page boundaries as required.
func (client LabClient) ListByResourceGroupComplete(ctx context.Context, resourceGroupName string, filter string, top *int32, orderBy string) (result ResponseWithContinuationLabIterator, err error) {
	result.page, err = client.ListByResourceGroup(ctx, resourceGroupName, filter, top, orderBy)
	return
}

// ListBySubscription list labs.
// Parameters:
// filter - the filter to apply on the operation.
func (client LabClient) ListBySubscription(ctx context.Context, filter string, top *int32, orderBy string) (result ResponseWithContinuationLabPage, err error) {
	result.fn = client.listBySubscriptionNextResults
	req, err := client.ListBySubscriptionPreparer(ctx, filter, top, orderBy)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "ListBySubscription", nil, "Failure preparing request")
		return
	}

	resp, err := client.ListBySubscriptionSender(req)
	if err != nil {
		result.rwcl.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "ListBySubscription", resp, "Failure sending request")
		return
	}

	result.rwcl, err = client.ListBySubscriptionResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "ListBySubscription", resp, "Failure responding to request")
	}

	return
}

// ListBySubscriptionPreparer prepares the ListBySubscription request.
func (client LabClient) ListBySubscriptionPreparer(ctx context.Context, filter string, top *int32, orderBy string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"subscriptionId": autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2015-05-21-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}
	if len(filter) > 0 {
		queryParameters["$filter"] = autorest.Encode("query", filter)
	}
	if top != nil {
		queryParameters["$top"] = autorest.Encode("query", *top)
	}
	if len(orderBy) > 0 {
		queryParameters["$orderBy"] = autorest.Encode("query", orderBy)
	}

	preparer := autorest.CreatePreparer(
		autorest.AsGet(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/providers/Microsoft.DevTestLab/labs", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// ListBySubscriptionSender sends the ListBySubscription request. The method will close the
// http.Response Body if it receives an error.
func (client LabClient) ListBySubscriptionSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// ListBySubscriptionResponder handles the response to the ListBySubscription request. The method always
// closes the http.Response Body.
func (client LabClient) ListBySubscriptionResponder(resp *http.Response) (result ResponseWithContinuationLab, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// listBySubscriptionNextResults retrieves the next set of results, if any.
func (client LabClient) listBySubscriptionNextResults(lastResults ResponseWithContinuationLab) (result ResponseWithContinuationLab, err error) {
	req, err := lastResults.responseWithContinuationLabPreparer()
	if err != nil {
		return result, autorest.NewErrorWithError(err, "dtl.LabClient", "listBySubscriptionNextResults", nil, "Failure preparing next results request")
	}
	if req == nil {
		return
	}
	resp, err := client.ListBySubscriptionSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		return result, autorest.NewErrorWithError(err, "dtl.LabClient", "listBySubscriptionNextResults", resp, "Failure sending next results request")
	}
	result, err = client.ListBySubscriptionResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "listBySubscriptionNextResults", resp, "Failure responding to next results request")
	}
	return
}

// ListBySubscriptionComplete enumerates all values, automatically crossing page boundaries as required.
func (client LabClient) ListBySubscriptionComplete(ctx context.Context, filter string, top *int32, orderBy string) (result ResponseWithContinuationLabIterator, err error) {
	result.page, err = client.ListBySubscription(ctx, filter, top, orderBy)
	return
}

// ListVhds list disk images available for custom image creation.
// Parameters:
// resourceGroupName - the name of the resource group.
// name - the name of the lab.
func (client LabClient) ListVhds(ctx context.Context, resourceGroupName string, name string) (result ResponseWithContinuationLabVhdPage, err error) {
	result.fn = client.listVhdsNextResults
	req, err := client.ListVhdsPreparer(ctx, resourceGroupName, name)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "ListVhds", nil, "Failure preparing request")
		return
	}

	resp, err := client.ListVhdsSender(req)
	if err != nil {
		result.rwclv.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "ListVhds", resp, "Failure sending request")
		return
	}

	result.rwclv, err = client.ListVhdsResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "ListVhds", resp, "Failure responding to request")
	}

	return
}

// ListVhdsPreparer prepares the ListVhds request.
func (client LabClient) ListVhdsPreparer(ctx context.Context, resourceGroupName string, name string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"name":              autorest.Encode("path", name),
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2015-05-21-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsPost(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}/listVhds", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// ListVhdsSender sends the ListVhds request. The method will close the
// http.Response Body if it receives an error.
func (client LabClient) ListVhdsSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// ListVhdsResponder handles the response to the ListVhds request. The method always
// closes the http.Response Body.
func (client LabClient) ListVhdsResponder(resp *http.Response) (result ResponseWithContinuationLabVhd, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// listVhdsNextResults retrieves the next set of results, if any.
func (client LabClient) listVhdsNextResults(lastResults ResponseWithContinuationLabVhd) (result ResponseWithContinuationLabVhd, err error) {
	req, err := lastResults.responseWithContinuationLabVhdPreparer()
	if err != nil {
		return result, autorest.NewErrorWithError(err, "dtl.LabClient", "listVhdsNextResults", nil, "Failure preparing next results request")
	}
	if req == nil {
		return
	}
	resp, err := client.ListVhdsSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		return result, autorest.NewErrorWithError(err, "dtl.LabClient", "listVhdsNextResults", resp, "Failure sending next results request")
	}
	result, err = client.ListVhdsResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "listVhdsNextResults", resp, "Failure responding to next results request")
	}
	return
}

// ListVhdsComplete enumerates all values, automatically crossing page boundaries as required.
func (client LabClient) ListVhdsComplete(ctx context.Context, resourceGroupName string, name string) (result ResponseWithContinuationLabVhdIterator, err error) {
	result.page, err = client.ListVhds(ctx, resourceGroupName, name)
	return
}

// PatchResource modify properties of labs.
// Parameters:
// resourceGroupName - the name of the resource group.
// name - the name of the lab.
func (client LabClient) PatchResource(ctx context.Context, resourceGroupName string, name string, lab Lab) (result Lab, err error) {
	req, err := client.PatchResourcePreparer(ctx, resourceGroupName, name, lab)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "PatchResource", nil, "Failure preparing request")
		return
	}

	resp, err := client.PatchResourceSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "PatchResource", resp, "Failure sending request")
		return
	}

	result, err = client.PatchResourceResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "dtl.LabClient", "PatchResource", resp, "Failure responding to request")
	}

	return
}

// PatchResourcePreparer prepares the PatchResource request.
func (client LabClient) PatchResourcePreparer(ctx context.Context, resourceGroupName string, name string, lab Lab) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"name":              autorest.Encode("path", name),
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2015-05-21-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsContentType("application/json; charset=utf-8"),
		autorest.AsPatch(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.DevTestLab/labs/{name}", pathParameters),
		autorest.WithJSON(lab),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// PatchResourceSender sends the PatchResource request. The method will close the
// http.Response Body if it receives an error.
func (client LabClient) PatchResourceSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// PatchResourceResponder handles the response to the PatchResource request. The method always
// closes the http.Response Body.
func (client LabClient) PatchResourceResponder(resp *http.Response) (result Lab, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}
