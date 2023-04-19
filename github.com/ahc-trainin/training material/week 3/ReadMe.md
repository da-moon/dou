# DOU by Tech Mahindra

## AHC Training Week 3

#### Basic JS and JSON
#### Fetch API and DOM Manipulation 
#### ES6 Syntax

<br/>
<br/>
<br/>
<br/>

### WEEK ALGORITHM

This problem was asked by Google.

The edit distance between two strings refers to the minimum number of character insertions, deletions, and substitutions required to change one string to the other. For example, the edit distance between “kitten” and “sitting” is three: substitute the “k” for “s”, substitute the “e” for “i”, and append a “g”.

Given two strings, compute the edit distance between them.

input 
“kitten” “sitting” 

output 
3


input 
typing “riding” 

output 
3



### WEEK EXCERCISE
At the end of the week you must have the following, this is the entire image
![image](imgs/project1.png)
<br/>

but in parts it should look like this
![image](imgs/project2.png)
remember is the same content but closer
![image](imgs/project3.png)

![image](imgs/project4.png)


### Requirements

Layout very similar, when you click on the central image you need to change it for one of the collection below every time, and move forward, first click, the first one, second, the second one and so on and so forth when you run out of them, return to the default image

when the button send is clicked you need to collect all the information from the form and display it below the image, remeber to use html validations for that

the right buttons on the nav bar needs to send you to specific sides of the page, like about, contact and home




### JS BASICS

#### Questions
* what is an array?
* what is an object in js?
* what is the prototype and classes and how they are different?
* what are is let, const and var and what are their differences?
* what is a promise?
* what is undefined and null values for?
* what is the scope of a variable?
* explain very simple the event loop?
* what is a constructor?

####  Exercises

Execute code in the console of any web page by f12 or right click inspect and in console start typing the following

```
console.log('AHC ROCKS!!!')
```

Very handy arrays,

explore the different ways to iterate over arrays

check the following

```
[1,2,3,4,5].map((x) => x + 1);
```
check the following

```
[1,2,3,4,5].foreach(console.log);
```

check the following

```
[1,2,3,4,5].reduce(Math.min);
[1,2,3,4,5].reduce(Math.max);
```

* write a piece of code on how you add values to an array at the end?
* write a piece of code on how you add values to an array at the beggining?
* write how do you reference the last value on an array?
* write how can you put dinamyc or calculated properties in a dictionary(object)?



####  References

https://developer.mozilla.org/es/docs/Web/JavaScript/Data_structures
https://developer.mozilla.org/es/docs/Web/JavaScript/EventLoop




### DOM and FETCH API
#### Questions
What is the dom and what it stands for?

What is event bubbling and event capture?

What data structure the dom uses?

What is the fetch api?

What is a promise?

#### Exercises

*When a button is clicked display an alert with the text hurray

*Put an input button and when it changes you need to write the same input below the input text but backwards

#### References 
https://developer.mozilla.org/es/docs/Web/JavaScript/Reference/Global_Objects/Promise
https://www.w3schools.com/js/js_htmldom.asp



### ES6 SYNTAX
#### Questions

How a function can receive optional parameters?

What are template literals?

What are tagged templates?

What are arrow functions, what happens if the arrow function has no body?

What is destrcturing in js?

What is async and await words for?




#### Excersises

*Write how would you combine the following 2 texts in 2 different variables 
first has const x1 = 'Hey dude!';
second has const x2 = 'You are awesome!';

*Write how would you destructure the following array in 3 variables [1,2,3],

*If you are exploring the following object
```
	{
		person: {
			name: 'John',
			age: 20
		}
	}
```
Trought destructuring how do you get the name?

*Write a very simple api fetch call using async and await





#### References 
https://www.divami.com/blog/top-ecmascript-es6-features-every-javascript-developer-should-know/
