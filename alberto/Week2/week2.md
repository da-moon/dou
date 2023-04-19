# Week 2
## CSS basics
### Float position vs display and how do they work?
Float and layout are properties of CSS which help us to control de layout of the webpage. With float we can set the position of an incoming element and it's alignment, by the other hand, display tells the browser where does an element is going to be render. to understand this we need to know that HTML has mainly two ways of displaying elements, the first one is block, every time we add a new element this will start on a new line and it will take al the width available, elements like h1,h2 or div use this type of display. The other way is inline, the elements with this property does not start on a new line and they take the width that they need, instead of the 100%.

### What is the selector for tag, id and class?
- For every element or HMTL tag we only need to specify it by typing it's name ``` p { ... }```
- A class is indentified by adding a "." before the name of the class that we are trying to make some changes ``` .Titles { ... }```
- Finally the ids we add "#" before the id of the element ``` #datePick { ... }```
### You have the following code? 
```
	<div>
		<button class="my-btn" >Hit me!</button>
	<div>
```
### How would you select the following button and what is the code to make it red, with white text, bordered and also with rounded corners?

``` 
    .my-btn {
        background-color: red;
        color: white;
        border: 2px solid #55555;
        border-radius: 1rem;
    }
```
### What are margins and paddings?
- The margins are a property which defines the space around the elements. We can add margins to the left, right, top and bottom.
- Paddings by the other hand defines the space inside the margins defined in the element.

### What does it mean that styles are in cascade?
It means that many stylesheet can be active for one simple document at the same time

## Pseudo elements & Pseudo class
### What are pseudoelements and what is the syntax they use?
Pseudo-elements are a little bit different but work in a similar way, under specific situations it will modify certain part of the element "creating a new one".

### What are pseudo classes mention 2 and how to write them?
A pseudo-class is a selector for elements that are in a specific state, these can either work by the order of rendering or even when the user interacts with them.

### What is the hover state of an html element and how can you use it for design with css?
Hover is a state from a pseudo-class, it tells us that we are intercating with the element, but it does no mean this has beem activate, it's usually triggered when the cursor is placed over the element itself.

## CSS Layouts
### What is flex?
Flex is the property on CSS that will tell the elements how much they could shrink or grow.

### What are the properties flex grow and flex shrink?
- Flex grow is the property that gives to an item the hability to grow if necessary
- Fles shrink is the one that will tell the item to shrink if necessary

## Responsive design
### What is responsive design?
Responsive design is a tecnique that developers use to create web pages, that could perform on a proper way on different devices (smartphone, tablets, pc), without making drastic changes.

### What are media queries?
Media queries are specific sentences that modifies the style of our webpage under certain circumstances.

### How does bootstrap manages the media queries or breakpoints?
Bootstrap has 8 breakpoints targeting a min-wodth for different resolutions, so when needed the content could be adjusted according to whats needed.

    Breakpoint	Class infix	Dimensions
    X-Small	    None	<576px
    Small	    sm	    ≥576px
    Medium	    md	    ≥768px
    Large	    lg	    ≥992px
    X-large     xl	    ≥1200px
    XX-large	xxl	    ≥1400px

## CSS Frameworks
### What are css frameworks and why they are useful?
Frameworks are a collection of libraires that helps us to create different elements without to much effort, this elements require minor changes and could be improvised. Some frameworks (most of them), may need to use JS so they could work.

### Mention 4 css frameworks.
- Bulma
- Bootstrap
- Material UI
- Tailwind

## Forms and validations
### What kind of types input admits?
HTML accepts a huge amount of inputs, for different situations, these ones are the most common:
- text.- input field
- radio.- displays a list of buttons for one selection
- checkbox.- similar tu radio but it has multiple selection
- submit.- a button for submitting the form
- button.- a clickable button
- color.- display a color picker
- file.- it opens a menu to upload files


### What are html validations?
Validations are very useful in forms, it helps us to submit a form under certain conditions, it prevents empty forms or incorrect characters.

### What is required attribute for?
It prevents a form to be submited if is empty

### What is pattern attribute for?
It sets a value pattern for the form.