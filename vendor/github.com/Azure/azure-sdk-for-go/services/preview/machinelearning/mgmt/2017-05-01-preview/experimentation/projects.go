package experimentation

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

// ProjectsClient is the these APIs allow end users to operate on Azure Machine Learning Team Account resources. They
// support CRUD operations for Azure Machine Learning Team Accounts.
type ProjectsClient struct {
	BaseClient
}

// NewProjectsClient creates an instance of the ProjectsClient client.
func NewProjectsClient(subscriptionID string) ProjectsClient {
	return NewProjectsClientWithBaseURI(DefaultBaseURI, subscriptionID)
}

// NewProjectsClientWithBaseURI creates an instance of the ProjectsClient client.
func NewProjectsClientWithBaseURI(baseURI string, subscriptionID string) ProjectsClient {
	return ProjectsClient{NewWithBaseURI(baseURI, subscriptionID)}
}

// CreateOrUpdate creates or updates a project with the specified parameters.
// Parameters:
// resourceGroupName - the name of the resource group to which the machine learning team account belongs.
// accountName - the name of the machine learning team account.
// workspaceName - the name of the machine learning team account workspace.
// projectName - the name of the machine learning project under a team account workspace.
// parameters - the parameters for creating or updating a project.
func (client ProjectsClient) CreateOrUpdate(ctx context.Context, resourceGroupName string, accountName string, workspaceName string, projectName string, parameters Project) (result Project, err error) {
	if err := validation.Validate([]validation.Validation{
		{TargetValue: accountName,
			Constraints: []validation.Constraint{{Target: "accountName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "accountName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "accountName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}},
		{TargetValue: workspaceName,
			Constraints: []validation.Constraint{{Target: "workspaceName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "workspaceName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "workspaceName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}},
		{TargetValue: projectName,
			Constraints: []validation.Constraint{{Target: "projectName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "projectName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "projectName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}},
		{TargetValue: parameters,
			Constraints: []validation.Constraint{{Target: "parameters.ProjectProperties", Name: validation.Null, Rule: false,
				Chain: []validation.Constraint{{Target: "parameters.ProjectProperties.FriendlyName", Name: validation.Null, Rule: true, Chain: nil}}}}}}); err != nil {
		return result, validation.NewError("experimentation.ProjectsClient", "CreateOrUpdate", err.Error())
	}

	req, err := client.CreateOrUpdatePreparer(ctx, resourceGroupName, accountName, workspaceName, projectName, parameters)
	if err != nil {
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "CreateOrUpdate", nil, "Failure preparing request")
		return
	}

	resp, err := client.CreateOrUpdateSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "CreateOrUpdate", resp, "Failure sending request")
		return
	}

	result, err = client.CreateOrUpdateResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "CreateOrUpdate", resp, "Failure responding to request")
	}

	return
}

// CreateOrUpdatePreparer prepares the CreateOrUpdate request.
func (client ProjectsClient) CreateOrUpdatePreparer(ctx context.Context, resourceGroupName string, accountName string, workspaceName string, projectName string, parameters Project) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"accountName":       autorest.Encode("path", accountName),
		"projectName":       autorest.Encode("path", projectName),
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
		"workspaceName":     autorest.Encode("path", workspaceName),
	}

	const APIVersion = "2017-05-01-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsContentType("application/json; charset=utf-8"),
		autorest.AsPut(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces/{workspaceName}/projects/{projectName}", pathParameters),
		autorest.WithJSON(parameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// CreateOrUpdateSender sends the CreateOrUpdate request. The method will close the
// http.Response Body if it receives an error.
func (client ProjectsClient) CreateOrUpdateSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// CreateOrUpdateResponder handles the response to the CreateOrUpdate request. The method always
// closes the http.Response Body.
func (client ProjectsClient) CreateOrUpdateResponder(resp *http.Response) (result Project, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK, http.StatusCreated),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// Delete deletes a project.
// Parameters:
// resourceGroupName - the name of the resource group to which the machine learning team account belongs.
// accountName - the name of the machine learning team account.
// workspaceName - the name of the machine learning team account workspace.
// projectName - the name of the machine learning project under a team account workspace.
func (client ProjectsClient) Delete(ctx context.Context, resourceGroupName string, accountName string, workspaceName string, projectName string) (result autorest.Response, err error) {
	if err := validation.Validate([]validation.Validation{
		{TargetValue: accountName,
			Constraints: []validation.Constraint{{Target: "accountName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "accountName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "accountName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}},
		{TargetValue: workspaceName,
			Constraints: []validation.Constraint{{Target: "workspaceName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "workspaceName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "workspaceName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}},
		{TargetValue: projectName,
			Constraints: []validation.Constraint{{Target: "projectName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "projectName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "projectName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}}}); err != nil {
		return result, validation.NewError("experimentation.ProjectsClient", "Delete", err.Error())
	}

	req, err := client.DeletePreparer(ctx, resourceGroupName, accountName, workspaceName, projectName)
	if err != nil {
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "Delete", nil, "Failure preparing request")
		return
	}

	resp, err := client.DeleteSender(req)
	if err != nil {
		result.Response = resp
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "Delete", resp, "Failure sending request")
		return
	}

	result, err = client.DeleteResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "Delete", resp, "Failure responding to request")
	}

	return
}

// DeletePreparer prepares the Delete request.
func (client ProjectsClient) DeletePreparer(ctx context.Context, resourceGroupName string, accountName string, workspaceName string, projectName string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"accountName":       autorest.Encode("path", accountName),
		"projectName":       autorest.Encode("path", projectName),
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
		"workspaceName":     autorest.Encode("path", workspaceName),
	}

	const APIVersion = "2017-05-01-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsDelete(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces/{workspaceName}/projects/{projectName}", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// DeleteSender sends the Delete request. The method will close the
// http.Response Body if it receives an error.
func (client ProjectsClient) DeleteSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// DeleteResponder handles the response to the Delete request. The method always
// closes the http.Response Body.
func (client ProjectsClient) DeleteResponder(resp *http.Response) (result autorest.Response, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK, http.StatusNoContent),
		autorest.ByClosing())
	result.Response = resp
	return
}

// Get gets the properties of the specified machine learning project.
// Parameters:
// resourceGroupName - the name of the resource group to which the machine learning team account belongs.
// accountName - the name of the machine learning team account.
// workspaceName - the name of the machine learning team account workspace.
// projectName - the name of the machine learning project under a team account workspace.
func (client ProjectsClient) Get(ctx context.Context, resourceGroupName string, accountName string, workspaceName string, projectName string) (result Project, err error) {
	if err := validation.Validate([]validation.Validation{
		{TargetValue: accountName,
			Constraints: []validation.Constraint{{Target: "accountName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "accountName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "accountName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}},
		{TargetValue: workspaceName,
			Constraints: []validation.Constraint{{Target: "workspaceName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "workspaceName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "workspaceName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}},
		{TargetValue: projectName,
			Constraints: []validation.Constraint{{Target: "projectName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "projectName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "projectName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}}}); err != nil {
		return result, validation.NewError("experimentation.ProjectsClient", "Get", err.Error())
	}

	req, err := client.GetPreparer(ctx, resourceGroupName, accountName, workspaceName, projectName)
	if err != nil {
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "Get", nil, "Failure preparing request")
		return
	}

	resp, err := client.GetSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "Get", resp, "Failure sending request")
		return
	}

	result, err = client.GetResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "Get", resp, "Failure responding to request")
	}

	return
}

// GetPreparer prepares the Get request.
func (client ProjectsClient) GetPreparer(ctx context.Context, resourceGroupName string, accountName string, workspaceName string, projectName string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"accountName":       autorest.Encode("path", accountName),
		"projectName":       autorest.Encode("path", projectName),
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
		"workspaceName":     autorest.Encode("path", workspaceName),
	}

	const APIVersion = "2017-05-01-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsGet(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces/{workspaceName}/projects/{projectName}", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// GetSender sends the Get request. The method will close the
// http.Response Body if it receives an error.
func (client ProjectsClient) GetSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// GetResponder handles the response to the Get request. The method always
// closes the http.Response Body.
func (client ProjectsClient) GetResponder(resp *http.Response) (result Project, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// ListByWorkspace lists all the available machine learning projects under the specified workspace.
// Parameters:
// accountName - the name of the machine learning team account.
// workspaceName - the name of the machine learning team account workspace.
// resourceGroupName - the name of the resource group to which the machine learning team account belongs.
func (client ProjectsClient) ListByWorkspace(ctx context.Context, accountName string, workspaceName string, resourceGroupName string) (result ProjectListResultPage, err error) {
	if err := validation.Validate([]validation.Validation{
		{TargetValue: accountName,
			Constraints: []validation.Constraint{{Target: "accountName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "accountName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "accountName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}},
		{TargetValue: workspaceName,
			Constraints: []validation.Constraint{{Target: "workspaceName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "workspaceName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "workspaceName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}}}); err != nil {
		return result, validation.NewError("experimentation.ProjectsClient", "ListByWorkspace", err.Error())
	}

	result.fn = client.listByWorkspaceNextResults
	req, err := client.ListByWorkspacePreparer(ctx, accountName, workspaceName, resourceGroupName)
	if err != nil {
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "ListByWorkspace", nil, "Failure preparing request")
		return
	}

	resp, err := client.ListByWorkspaceSender(req)
	if err != nil {
		result.plr.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "ListByWorkspace", resp, "Failure sending request")
		return
	}

	result.plr, err = client.ListByWorkspaceResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "ListByWorkspace", resp, "Failure responding to request")
	}

	return
}

// ListByWorkspacePreparer prepares the ListByWorkspace request.
func (client ProjectsClient) ListByWorkspacePreparer(ctx context.Context, accountName string, workspaceName string, resourceGroupName string) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"accountName":       autorest.Encode("path", accountName),
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
		"workspaceName":     autorest.Encode("path", workspaceName),
	}

	const APIVersion = "2017-05-01-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsGet(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces{workspaceName}/projects", pathParameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// ListByWorkspaceSender sends the ListByWorkspace request. The method will close the
// http.Response Body if it receives an error.
func (client ProjectsClient) ListByWorkspaceSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// ListByWorkspaceResponder handles the response to the ListByWorkspace request. The method always
// closes the http.Response Body.
func (client ProjectsClient) ListByWorkspaceResponder(resp *http.Response) (result ProjectListResult, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}

// listByWorkspaceNextResults retrieves the next set of results, if any.
func (client ProjectsClient) listByWorkspaceNextResults(lastResults ProjectListResult) (result ProjectListResult, err error) {
	req, err := lastResults.projectListResultPreparer()
	if err != nil {
		return result, autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "listByWorkspaceNextResults", nil, "Failure preparing next results request")
	}
	if req == nil {
		return
	}
	resp, err := client.ListByWorkspaceSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		return result, autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "listByWorkspaceNextResults", resp, "Failure sending next results request")
	}
	result, err = client.ListByWorkspaceResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "listByWorkspaceNextResults", resp, "Failure responding to next results request")
	}
	return
}

// ListByWorkspaceComplete enumerates all values, automatically crossing page boundaries as required.
func (client ProjectsClient) ListByWorkspaceComplete(ctx context.Context, accountName string, workspaceName string, resourceGroupName string) (result ProjectListResultIterator, err error) {
	result.page, err = client.ListByWorkspace(ctx, accountName, workspaceName, resourceGroupName)
	return
}

// Update updates a project with the specified parameters.
// Parameters:
// resourceGroupName - the name of the resource group to which the machine learning team account belongs.
// accountName - the name of the machine learning team account.
// workspaceName - the name of the machine learning team account workspace.
// projectName - the name of the machine learning project under a team account workspace.
// parameters - the parameters for updating a machine learning team account.
func (client ProjectsClient) Update(ctx context.Context, resourceGroupName string, accountName string, workspaceName string, projectName string, parameters ProjectUpdateParameters) (result Project, err error) {
	if err := validation.Validate([]validation.Validation{
		{TargetValue: accountName,
			Constraints: []validation.Constraint{{Target: "accountName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "accountName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "accountName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}},
		{TargetValue: workspaceName,
			Constraints: []validation.Constraint{{Target: "workspaceName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "workspaceName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "workspaceName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}},
		{TargetValue: projectName,
			Constraints: []validation.Constraint{{Target: "projectName", Name: validation.MaxLength, Rule: 50, Chain: nil},
				{Target: "projectName", Name: validation.MinLength, Rule: 5, Chain: nil},
				{Target: "projectName", Name: validation.Pattern, Rule: `^[a-zA-Z0-9]*$`, Chain: nil}}}}); err != nil {
		return result, validation.NewError("experimentation.ProjectsClient", "Update", err.Error())
	}

	req, err := client.UpdatePreparer(ctx, resourceGroupName, accountName, workspaceName, projectName, parameters)
	if err != nil {
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "Update", nil, "Failure preparing request")
		return
	}

	resp, err := client.UpdateSender(req)
	if err != nil {
		result.Response = autorest.Response{Response: resp}
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "Update", resp, "Failure sending request")
		return
	}

	result, err = client.UpdateResponder(resp)
	if err != nil {
		err = autorest.NewErrorWithError(err, "experimentation.ProjectsClient", "Update", resp, "Failure responding to request")
	}

	return
}

// UpdatePreparer prepares the Update request.
func (client ProjectsClient) UpdatePreparer(ctx context.Context, resourceGroupName string, accountName string, workspaceName string, projectName string, parameters ProjectUpdateParameters) (*http.Request, error) {
	pathParameters := map[string]interface{}{
		"accountName":       autorest.Encode("path", accountName),
		"projectName":       autorest.Encode("path", projectName),
		"resourceGroupName": autorest.Encode("path", resourceGroupName),
		"subscriptionId":    autorest.Encode("path", client.SubscriptionID),
		"workspaceName":     autorest.Encode("path", workspaceName),
	}

	const APIVersion = "2017-05-01-preview"
	queryParameters := map[string]interface{}{
		"api-version": APIVersion,
	}

	preparer := autorest.CreatePreparer(
		autorest.AsContentType("application/json; charset=utf-8"),
		autorest.AsPatch(),
		autorest.WithBaseURL(client.BaseURI),
		autorest.WithPathParameters("/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.MachineLearningExperimentation/accounts/{accountName}/workspaces/{workspaceName}/projects/{projectName}", pathParameters),
		autorest.WithJSON(parameters),
		autorest.WithQueryParameters(queryParameters))
	return preparer.Prepare((&http.Request{}).WithContext(ctx))
}

// UpdateSender sends the Update request. The method will close the
// http.Response Body if it receives an error.
func (client ProjectsClient) UpdateSender(req *http.Request) (*http.Response, error) {
	return autorest.SendWithSender(client, req,
		azure.DoRetryWithRegistration(client.Client))
}

// UpdateResponder handles the response to the Update request. The method always
// closes the http.Response Body.
func (client ProjectsClient) UpdateResponder(resp *http.Response) (result Project, err error) {
	err = autorest.Respond(
		resp,
		client.ByInspecting(),
		azure.WithErrorUnlessStatusCode(http.StatusOK),
		autorest.ByUnmarshallingJSON(&result),
		autorest.ByClosing())
	result.Response = autorest.Response{Response: resp}
	return
}
