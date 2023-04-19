# Week 7
## HOCS
### What are hocs?
By definition HOCS are High order components, this special functions receive a component and return a completely new one. Any component in react receive props and turns them into UI which the users will interact with, by the other hand HOCS receive components and applies them new logic so this could perfomr different tasks, giving as result a new component.

### Where can you use HOCS?
One greate example is following design patterns, where in one file we declare only the structure of our component, the logic will be handled in a HOC that will receive that previous component.

### Whar are high order functions?
Similar as HOCS, in JS this functions receive a function and returns a function, thanks to thios we can keep an specicific state of a previous function and apply it to new ones.

## Router
### What is routing?
It's the way we navigate among our different views in our web pages. In technical language, it allows us to change our URL and sync it with the UI.

### How the server should sync with the client to handle routing?
- In common websites we type an initial URL, and it sends a request to the server, which will send back an HTML page. This is how it will work across the whole web page, whenever we click on a link we will be making requests and the server will be sending us HTML pages.
- With react it works different, at the beginning we do the same request and the server will send us the HTML and also the compile code from React, which will take the control from the APP, by this we won't need to make requests to the server unless it's 100% necessary. All of the routing will be handle by react.

### What are single page applications?
SPA is a type of webpage where everything is dislpayed on a single file and it will change according to the requests from the user, bringing new data from the server and updating the UI, instead of the loading the entire page.

### What are multi pages applications?
MPA are more traditional, it requires to load the page according to the requests. They are usually bigger than SPAs because of the amount of content they handle.

### What is the hash in a url, what is used for?
The hash (#) symbol in a URL represents a fragment, when the hash is typed on the URL it's targetting to an specific part (or code) form our webpage. The fragment is only indentifyed by the browser and it's not required to contact the server.

## Forms
### What is react hook forms and when is good to use it?
- It's an API that allows us to interact with forms using refs instead of depeneding on the state control of the inputs.
- There isn't an specicif scenario where hook forms ain't needed, it's just another way of working with forms.

### Why do we need validation in forms?
When we are sending data to our server is important to do some validantions, thanks to this we can be sure of what type of data is sent and the backend would receive what is expected, form this way we avoid errors or inconsistent results.
