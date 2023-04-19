# Main Activity: CI/CD with GitHub Actions

### In this activity, we will learn how to use GitHub Actions to build your microservices created on the previous sprint.

## Instructions:

1. Go to your demo-app repository.
2. Create a GithHub Actions Workflow following these steps:
 - Create a .github/workflows directory in your repository on GitHub if this directory does not already exist.
 - In the .github/workflows directory, create a file named github-actions-demo.yml. For more information, see "Creating new files."

3. Copy the following YAML contents into the github-actions-demo.yml file:

``` yaml

name: GitHub Actions Demo
on: [push]
jobs:
  Explore-GitHub-Actions:
    runs-on: ubuntu-latest
    steps:
      - run: echo "🎉 The job was automatically triggered!"
```

4. Push your changes to GitHub and verify that the GitHub Actions workflow is working.
5. Change the following:
- The name of the job to "Docker-Build-Demo"
- the trigger to only respond to pushes to the master branch
- the steps to build the Docker images that you created in the previous sprint

6. Once you have finished, you can push your changes to GitHub and verify that the GitHub Actions workflow is working.

7. Lastly, add the docker build steps of the other microservices to the GitHub Actions workflow.
