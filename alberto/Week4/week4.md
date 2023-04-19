# Week 4
## PACKAGE MANAGERS
### what is a package manager for?
They are tools that helps us to install different types of resources to our projects.

### npm vs yarn differences?
There are several differences between these two, but mainly, Yarn it's an 'extension' to NPM, because it covers all of the misteps that NPM has and tries to improve all of it's cons. All of this ended up giving us a more faster, secure and reliable package manager.

### why yarn born in the first place?
It was meant to be a replacement to NPM, for projects developed with Node.js and that needed packages.

### what are dev dependencies?
It's an special type of dependencies, that will not be installed when we build our projects. The packages de we specified on devDependencies, are meant only for developers and they are not needed for a production build.

### what are peer dependencies?
This type of dependencies are used to specify that our packages are compatible with a specific version of a npm package.

### scripts? what are they for
Scripts are pieces of code that give us the opportunity to add extra functionalities to our project. From setting automatic production builds, to prepare everything for testing.

## Advance JS
### What hoisting is?
When we declare a function it doesn't matter where we call it, the hoisting will 'relocate' it to the top so this could be executed. Although, this does not apply for arrow functions, they need to be declared before being called.
### what happens when
```
awesome();
function awesome() {
}
```
The code will run without any trouble, because it's a normal function.

```
awesome();
const awesome = () => {
}
```
Contrary to the other case, this will not work, arrow functions need to be declared before.

## What are the event phases(bubbling, capturing) and how they are different?
Event phases are the way some actions will be spread across different component.
- capturing is when an event goes beyond the element it was meant for and it's spread across it's childrens.
- Bubbling is the opposite way, it spread the element from the children to the root element.

### What is the prototype in js and why is useful?
Prototypes are the way objects inherit properties.

### Why this is possible `4 + '4'` and why is the difference between `4 == '4'` && `4 === '4'`?
- In js the '+' symbol represent two different operations, adding or concatenation. Adding will only work if we have to numbers, but when one of the elements is a string it will be a concatenation, and the number will be parsed to a string, giving us the next result `4 + '4' => '44' `.
- There are two types of the equality operation in JS, the first one is an abstract comparison, which will try to make a type conversion so the elements could match and the make the comparison. The other one is an strict comparison, which will look for equality in either type and value.

### What is type coercion?
In JS coercion, is the implicit conversion of values according to certain operations, for example a number to string for concatenation.

### Check the output of `4 == '4'` and `4 === '4'` analize their differences
- The first one will run as true, because the first one is abstract and it does not look at the type of the values.
- The second one is false, it's an strict equality and it requires to be the same type of values.

## Version control
### What is version control for?
It helps us to keep a record of all of the changes we made to our project.

### What is a merge conflict and how do you solve it?
It happens when we have a block of code that is replacing, interfiring or blocking an existing one. To solve it we need to adapt our commit and accept those changes or replaace the existing one with one that does not interfere.

### What tools are out there to help you with git?
- gitlab
- github
- gitkraken
- 
### what are the remotes in git?
A repositorie that is located in either a server or a different pc than ours.

### What a for is?

### What are tags for?
Are specific 'pointers' that target to a commit.

### What is the stage?
Is a state of the branch, where we need to specify to git that new files or changes are incoming.

### What is the stash?
Stash saves the changes that we have made to our branch, so we can work on something else.

### How do you add changes to your stage?
To add any changes we need to add the files with the command `git add .`, after that we need to commit and add a message `git commit -m 'message'`

### How do you pass stage changes to your remote?
We need to make a push, that way our changes will be added to the original repositorie `git push --set-upstream origin`

## Module bundlers
### What are bundlers for?
Bundlers are tools that compile all of our JS code and it dependencies, to one single file.

### Get cons and pros over rollup and webpack?
Pros
- Both make our code more reliable.
- They helps us to automatise any modifications we made..
- Our bundles could be very small.
- The amount of plugins is amazing.

Cons
- It could be very complicated to understand at the beginning.
- As you project grows, more plugins are needed and new configurations is requeired.
- It can trow errors is it's not updated or setup properly.

### What is babel and why is popular nowadays?
Babel is a JS compiler, that converts our JSX code to ES5.

## Prettier and linters
### What are formaters for?
Formaters are tools that helps us to keep certain "structure" on oru code, making it more consistent, reliable, and easier to read.

### What are linterns for?
linterns are tools used for typing better code, they check for syntax errors, it trows errors when we are having bad practices, it also provides suggestions to improve our code.

### Mention at least 3 rules of eslint?
- no-obj-calls: disallow calling global object properties as functions
- no-unused-vars: disallow unused variables
- camelcase: enforce camelcase naming convention