# Demo Custom Javascript Github Action

This demo follows the official documentation from Github for [Createing a Javascript action](https://docs.github.com/en/actions/creating-actions/creating-a-javascript-action), which is for research and development purposes to be translated into a use-case for a current DOU client.

# How you DOU'ing world JavaScript action

This action prints "How you DOU'ing World" or "How you DOU'ing" + the name of a person to greet to the log.

## Inputs

### `who-to-greet`

**Required** The name of the person to greet. Default `"World"`.

## Outputs

### `time`

The time we greeted you.

## Example usage

uses: actions/demo-custom-javascript-action@v1.1
with:
  who-to-greet: 'Mona the Octocat'

## Testing out your action in a workflow
When an action is in a private repository, the action can only be used in workflows in the same repository. Public actions can be used by workflows in any repository.