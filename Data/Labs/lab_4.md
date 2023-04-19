# Data Lab 💾

# Practice #4 - Data visualization

### Objective:

- Using the data from Practice #1, let’s use some services for data visualization

__Details:__

1. Create a `synapse` view with the teams-data from practice #1 with the below conditions 
   1. Order by: points, name (lexicographic ascending order)
   2. Filter out all the teams which have 0 points
2. Final schema should be:
```text
Name - Format: Capitalized name (ABBRV.) - Example: Argentina (ARG.)
Points - numeric
Stats - string with the below format: “W: <W>, T: <T>, L: <L>” - Example: “W: 2, T:1, L: 1”
```
3. Create a `synapse` view to report the teams with more scored goals. Design schema and
output format
4. Try creating similar reports and add some charts... find the right `azure-service` for this.

__Extras:__

- Is there a way we can automate this process?
- What would happen if we need to update an existing view?
- What would be some validations and/or monitors we can add to these views?
