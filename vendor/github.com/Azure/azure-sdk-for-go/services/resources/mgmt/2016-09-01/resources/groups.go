package resources

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
	"github.com/Azure/go-autorest/autorest/validation"
	"net/http"
)

// GroupsClient is the provides operations for working with resources and resource groups.
type GroupsClient struct {
	BaseClient
}

// NewGroupsClient creates an instance of the GroupsClient client.
func NewGroupsClient(subscriptionID string) GroupsClient {
	return NewGroupsClientWithBaseURI(DefaultBaseURI, subscriptionID)
}

// NewGroupsClientWithBaseURI creates an instance of the GroupsClient client.
func NewGroupsClientWithBaseURI(baseURI string, subscriptionID string) GroupsClient {
	return GroupsClient{NewWithBaseURI(baseURI, subscriptionID)}
}

// CheckExistence checks whether a resource group exists.
// Parameters:
// resourceGroupName - the name of the resource group to check. The name is case insensitive.
func (client GroupsClient) CheckExistence(ctx context.Context, resourceGroupName string) (result autorest.Response, err error) {
	if err := validation.Validate([]validation.Validation{
		{TargetValue: resourceGroupName,
			Constraints: []validation.Constraint{{Target: "resourceGroupName", Name: validation.MaxLength, Rule: 90, Chain: nil},
				{Target: "resourceGroupName", Name: validation.MinLength, Rule: 1, Chain: nil},
				{Target: "resourceGroupName", Name: validation.Pattern, Rule: `^[-\w\._\(\)]+$`, Chain: nil}}}}); err != nil {
		return result, validation.NewError("resources.GroupsClient", "CheckExistence", err.Error())
	}

	req, err := client.CheckExistencePreparer(ctx, resourceGroupName)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "CheckExistence", nil, "Failure preparing request")
		return
	}

	resp, err := client.CheckExistenceSender(req)
	if err != nil {
		result.Response = resp
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "CheckExistence", resp, "Failure sending request")
		return
	}

	result, err = client.CheckExistenceResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "CheckExistence", resp, "Failure responding to request")
	}

	return
}

// CheckExistencePreparer prepares the CheckExistence request.
func (client GroupsClient) CheckExistencePreparer(ctx context.Context, resourceGroupName string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2016-09-01"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsHead(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// CheckExistenceSender sends the CheckExistence request. The method will close the
// http.Response Body if it receives an error.
func (client GroupsClient) CheckExistenceSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// CheckExistenceResponder handles the response to the CheckExistence request. The method always
// closes the http.Response Body.
func (client GroupsClient) CheckExistenceResponder(resp *http.Response) (result autorest.Response, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK, http.StatusNoContent, http.StatusNotFound),
		autorest.ByClosing())
	result.Response = resp
	return
}

// CreateOrUpdate creates a resource group.
// Parameters:
// resourceGroupName - the name of the resource group to create or update.
// parameters - parameters supplied to the create or update a resource group.
func (client GroupsClient) CreateOrUpdate(ctx context.Context, resourceGroupName string, parameters Group) (result Group, err error) {
	if err := validation.Validate([]validation.Validation{
		{TargetValue: resourceGroupName,
			Constraints: []validation.Constraint{{Target: "resourceGroupName", Name: validation.MaxLength, Rule: 90, Chain: nil},
				{Target: "resourceGroupName", Name: validation.MinLength, Rule: 1, Chain: nil},
				{Target: "resourceGroupName", Name: validation.Pattern, Rule: `^[-\w\._\(\)]+$`, Chain: nil}}},
		{TargetValue: parameters,
			Constraints: []validation.Constraint{{Target: "parameters.Location", Name: validation.Null, Rule: true, Chain: nil}}}}); err != nil {
		return result, validation.NewError("resources.GroupsClient", "CreateOrUpdate", err.Error())
	}

	req, err := client.CreateOrUpdatePreparer(ctx, resourceGroupName, parameters)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "CreateOrUpdate", nil, "Failure preparing request")
		return
	}

	resp, err := client.CreateOrUpdateSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "CreateOrUpdate", resp, "Failure sending request")
		return
	}

	result, err = client.CreateOrUpdateResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "CreateOrUpdate", resp, "Failure responding to request")
	}

	return
}

// CreateOrUpdatePreparer prepares the CreateOrUpdate request.
func (client GroupsClient) CreateOrUpdatePreparer(ctx context.Context, resourceGroupName string, parameters Group) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2016-09-01"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsContentType("application/json; charset=utf-8"),
		autorest.AsPut(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}", pathParameters),
		autorest.WithJSON(parameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// CreateOrUpdateSender sends the CreateOrUpdate request. The method will close the
// http.Response Body if it receives an error.
func (client GroupsClient) CreateOrUpdateSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// CreateOrUpdateResponder handles the response to the CreateOrUpdate request. The method always
// closes the http.Response Body.
func (client GroupsClient) CreateOrUpdateResponder(resp *http.Response) (result Group, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK, http.StatusCreated),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// Delete when you delete a resource group, all of its resources are also deleted. Deleting a resource group deletes
// all of its template deployments and currently stored operations.
// Parameters:
// resourceGroupName - the name of the resource group to delete. The name is case insensitive.
func (client GroupsClient) Delete(ctx context.Context, resourceGroupName string) (result GroupsDeleteFuture, err error) {
	if err := validation.Validate([]validation.Validation{
		{TargetValue: resourceGroupName,
			Constraints: []validation.Constraint{{Target: "resourceGroupName", Name: validation.MaxLength, Rule: 90, Chain: nil},
				{Target: "resourceGroupName", Name: validation.MinLength, Rule: 1, Chain: nil},
				{Target: "resourceGroupName", Name: validation.Pattern, Rule: `^[-\w\._\(\)]+$`, Chain: nil}}}}); err != nil {
		return result, validation.NewError("resources.GroupsClient", "Delete", err.Error())
	}

	req, err := client.DeletePreparer(ctx, resourceGroupName)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "Delete", nil, "Failure preparing request")
		return
	}

	result, err = client.DeleteSender(req)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "Delete", result.Response(), "Failure sending request")
		return
	}

	return
}

// DeletePreparer prepares the Delete request.
func (client GroupsClient) DeletePreparer(ctx context.Context, resourceGroupName string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2016-09-01"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsDelete(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// DeleteSender sends the Delete request. The method will close the
// http.Response Body if it receives an error.
func (client GroupsClient) DeleteSender(req *http.Request) (future GroupsDeleteFuture, err error) {
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

// DeleteResponder handles the response to the Delete request. The method always
// closes the http.Response Body.
func (client GroupsClient) DeleteResponder(resp *http.Response) (result autorest.Response, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK, http.StatusAccepted),
		autorest.ByClosing())
	result.Response = resp
	return
}

// ExportTemplate captures the specified resource group as a template.
// Parameters:
// resourceGroupName - the name of the resource group to export as a template.
// parameters - parameters for exporting the template.
func (client GroupsClient) ExportTemplate(ctx context.Context, resourceGroupName string, parameters ExportTemplateRequest) (result GroupExportResult, err error) {
	if err := validation.Validate([]validation.Validation{
		{TargetValue: resourceGroupName,
			Constraints: []validation.Constraint{{Target: "resourceGroupName", Name: validation.MaxLength, Rule: 90, Chain: nil},
				{Target: "resourceGroupName", Name: validation.MinLength, Rule: 1, Chain: nil},
				{Target: "resourceGroupName", Name: validation.Pattern, Rule: `^[-\w\._\(\)]+$`, Chain: nil}}}}); err != nil {
		return result, validation.NewError("resources.GroupsClient", "ExportTemplate", err.Error())
	}

	req, err := client.ExportTemplatePreparer(ctx, resourceGroupName, parameters)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "ExportTemplate", nil, "Failure preparing request")
		return
	}

	resp, err := client.ExportTemplateSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "ExportTemplate", resp, "Failure sending request")
		return
	}

	result, err = client.ExportTemplateResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "ExportTemplate", resp, "Failure responding to request")
	}

	return
}

// ExportTemplatePreparer prepares the ExportTemplate request.
func (client GroupsClient) ExportTemplatePreparer(ctx context.Context, resourceGroupName string, parameters ExportTemplateRequest) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2016-09-01"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsContentType("application/json; charset=utf-8"),
		autorest.AsPost(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}/exportTemplate", pathParameters),
		autorest.WithJSON(parameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// ExportTemplateSender sends the ExportTemplate request. The method will close the
// http.Response Body if it receives an error.
func (client GroupsClient) ExportTemplateSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// ExportTemplateResponder handles the response to the ExportTemplate request. The method always
// closes the http.Response Body.
func (client GroupsClient) ExportTemplateResponder(resp *http.Response) (result GroupExportResult, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// Get gets a resource group.
// Parameters:
// resourceGroupName - the name of the resource group to get. The name is case insensitive.
func (client GroupsClient) Get(ctx context.Context, resourceGroupName string) (result Group, err error) {
	if err := validation.Validate([]validation.Validation{
		{TargetValue: resourceGroupName,
			Constraints: []validation.Constraint{{Target: "resourceGroupName", Name: validation.MaxLength, Rule: 90, Chain: nil},
				{Target: "resourceGroupName", Name: validation.MinLength, Rule: 1, Chain: nil},
				{Target: "resourceGroupName", Name: validation.Pattern, Rule: `^[-\w\._\(\)]+$`, Chain: nil}}}}); err != nil {
		return result, validation.NewError("resources.GroupsClient", "Get", err.Error())
	}

	req, err := client.GetPreparer(ctx, resourceGroupName)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "Get", nil, "Failure preparing request")
		return
	}

	resp, err := client.GetSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "Get", resp, "Failure sending request")
		return
	}

	result, err = client.GetResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "Get", resp, "Failure responding to request")
	}

	return
}

// GetPreparer prepares the Get request.
func (client GroupsClient) GetPreparer(ctx context.Context, resourceGroupName string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2016-09-01"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsGet(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// GetSender sends the Get request. The method will close the
// http.Response Body if it receives an error.
func (client GroupsClient) GetSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// GetResponder handles the response to the Get request. The method always
// closes the http.Response Body.
func (client GroupsClient) GetResponder(resp *http.Response) (result Group, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// List gets all the resource groups for a subscription.
// Parameters:
// filter - the filter to apply on the operation.
// top - the number of results to return. If null is passed, returns all resource groups.
func (client GroupsClient) List(ctx context.Context, filter string, top *int32) (result GroupListResultPage, err error) {
	result.fn = client.listNextResults
	req, err := client.ListPreparer(ctx, filter, top)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "List", nil, "Failure preparing request")
		return
	}

	resp, err := client.ListSender(req)
	if err != nil {
		result.glr.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "List", resp, "Failure sending request")
		return
	}

	result.glr, err = client.ListResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "List", resp, "Failure responding to request")
	}

	return
}

// ListPreparer prepares the List request.
func (client GroupsClient) ListPreparer(ctx context.Context, filter string, top *int32) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"subscriptionId": autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2016-09-01"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}
	if len(filter) > 0 {
		queryParameters["$filter"] = autorest.Encode("query", filter)
	}
	if top != nil {
		queryParameters["$top"] = autorest.Encode("query", *top)
	}

	preparer := autorest.CreatePreparer(
		autorest.AsGet(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourcegroups", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// ListSender sends the List request. The method will close the
// http.Response Body if it receives an error.
func (client GroupsClient) ListSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// ListResponder handles the response to the List request. The method always
// closes the http.Response Body.
func (client GroupsClient) ListResponder(resp *http.Response) (result GroupListResult, err error) {
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
func (client GroupsClient) listNextResults(lastResults GroupListResult) (result GroupListResult, err error) {
	req, err := lastResults.groupListResultPreparer()
	if err != nil {
		return result, autorest.NewErrorWithError(err, "resources.GroupsClient", "listNextResults", nil, "Failure preparing next results request")
	}
	if req == nil {
		return
	}
	resp, err := client.ListSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		return result, autorest.NewErrorWithError(err, "resources.GroupsClient", "listNextResults", resp, "Failure sending next results request")
	}
	result, err = client.ListResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "listNextResults", resp, "Failure responding to next results request")
	}
	return
}

// ListComplete enumerates all values, automatically crossing page boundaries as required.
func (client GroupsClient) ListComplete(ctx context.Context, filter string, top *int32) (result GroupListResultIterator, err error) {
	result.page, err = client.List(ctx, filter, top)
	return
}

// ListResources get all the resources for a resource group.
// Parameters:
// resourceGroupName - the resource group with the resources to get.
// filter - the filter to apply on the operation.
// expand - the $expand query parameter
// top - the number of results to return. If null is passed, returns all resources.
func (client GroupsClient) ListResources(ctx context.Context, resourceGroupName string, filter string, expand string, top *int32) (result ListResultPage, err error) {
	if err := validation.Validate([]validation.Validation{
		{TargetValue: resourceGroupName,
			Constraints: []validation.Constraint{{Target: "resourceGroupName", Name: validation.MaxLength, Rule: 90, Chain: nil},
				{Target: "resourceGroupName", Name: validation.MinLength, Rule: 1, Chain: nil},
				{Target: "resourceGroupName", Name: validation.Pattern, Rule: `^[-\w\._\(\)]+$`, Chain: nil}}}}); err != nil {
		return result, validation.NewError("resources.GroupsClient", "ListResources", err.Error())
	}

	result.fn = client.listResourcesNextResults
	req, err := client.ListResourcesPreparer(ctx, resourceGroupName, filter, expand, top)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "ListResources", nil, "Failure preparing request")
		return
	}

	resp, err := client.ListResourcesSender(req)
	if err != nil {
		result.lr.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "ListResources", resp, "Failure sending request")
		return
	}

	result.lr, err = client.ListResourcesResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "ListResources", resp, "Failure responding to request")
	}

	return
}

// ListResourcesPreparer prepares the ListResources request.
func (client GroupsClient) ListResourcesPreparer(ctx context.Context, resourceGroupName string, filter string, expand string, top *int32) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2016-09-01"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}
	if len(filter) > 0 {
		queryParameters["$filter"] = autorest.Encode("query", filter)
	}
	if len(expand) > 0 {
		queryParameters["$expand"] = autorest.Encode("query", expand)
	}
	if top != nil {
		queryParameters["$top"] = autorest.Encode("query", *top)
	}

	preparer := autorest.CreatePreparer(
		autorest.AsGet(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/resources", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// ListResourcesSender sends the ListResources request. The method will close the
// http.Response Body if it receives an error.
func (client GroupsClient) ListResourcesSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// ListResourcesResponder handles the response to the ListResources request. The method always
// closes the http.Response Body.
func (client GroupsClient) ListResourcesResponder(resp *http.Response) (result ListResult, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// listResourcesNextResults retrieves the next set of results, if any.
func (client GroupsClient) listResourcesNextResults(lastResults ListResult) (result ListResult, err error) {
	req, err := lastResults.listResultPreparer()
	if err != nil {
		return result, autorest.NewErrorWithError(err, "resources.GroupsClient", "listResourcesNextResults", nil, "Failure preparing next results request")
	}
	if req == nil {
		return
	}
	resp, err := client.ListResourcesSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		return result, autorest.NewErrorWithError(err, "resources.GroupsClient", "listResourcesNextResults", resp, "Failure sending next results request")
	}
	result, err = client.ListResourcesResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "listResourcesNextResults", resp, "Failure responding to next results request")
	}
	return
}

// ListResourcesComplete enumerates all values, automatically crossing page boundaries as required.
func (client GroupsClient) ListResourcesComplete(ctx context.Context, resourceGroupName string, filter string, expand string, top *int32) (result ListResultIterator, err error) {
	result.page, err = client.ListResources(ctx, resourceGroupName, filter, expand, top)
	return
}

// Patch resource groups can be updated through a simple PATCH operation to a group address. The format of the request
// is the same as that for creating a resource group. If a field is unspecified, the current value is retained.
// Parameters:
// resourceGroupName - the name of the resource group to update. The name is case insensitive.
// parameters - parameters supplied to update a resource group.
func (client GroupsClient) Patch(ctx context.Context, resourceGroupName string, parameters Group) (result Group, err error) {
	if err := validation.Validate([]validation.Validation{
		{TargetValue: resourceGroupName,
			Constraints: []validation.Constraint{{Target: "resourceGroupName", Name: validation.MaxLength, Rule: 90, Chain: nil},
				{Target: "resourceGroupName", Name: validation.MinLength, Rule: 1, Chain: nil},
				{Target: "resourceGroupName", Name: validation.Pattern, Rule: `^[-\w\._\(\)]+$`, Chain: nil}}}}); err != nil {
		return result, validation.NewError("resources.GroupsClient", "Patch", err.Error())
	}

	req, err := client.PatchPreparer(ctx, resourceGroupName, parameters)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "Patch", nil, "Failure preparing request")
		return
	}

	resp, err := client.PatchSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "Patch", resp, "Failure sending request")
		return
	}

	result, err = client.PatchResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "resources.GroupsClient", "Patch", resp, "Failure responding to request")
	}

	return
}

// PatchPreparer prepares the Patch request.
func (client GroupsClient) PatchPreparer(ctx context.Context, resourceGroupName string, parameters Group) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
	}

	const APIVersion = "2016-09-01"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsContentType("application/json; charset=utf-8"),
		autorest.AsPatch(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourcegroups/{resourceGroupName}", pathParameters),
		autorest.WithJSON(parameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// PatchSender sends the Patch request. The method will close the
// http.Response Body if it receives an error.
func (client GroupsClient) PatchSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// PatchResponder handles the response to the Patch request. The method always
// closes the http.Response Body.
func (client GroupsClient) PatchResponder(resp *http.Response) (result Group, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}
