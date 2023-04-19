const link = document.querySelector('a');
link.textContent = 'Mozilla Developer Network';
link.href = 'https://developer.mozilla.org';

const sect = document.querySelector('section');
const para = document.createElement('p');
para.textContent = 'We hope you enjoyed the ride.';
sect.appendChild(para);
const text = document.createTextNode(' — the premier source for web development knowledge.');
const linkPara = document.querySelector('p');
linkPara.appendChild(text);

const button = document.createElement("button");
button.textContent = "Say hi"
button.onclick = () => alert("hi");
sect.appendChild(button);

para.setAttribute('class', 'highlight');

// container
const div = document.createElement("div");

// === dynamic div
const dynamicDivTitle = document.createElement("h1");
dynamicDivTitle.textContent = "----- Dynamic <div>";
div.appendChild(dynamicDivTitle);

const dynamicDiv = document.createElement("div");
dynamicDiv.style.border = "5px dotted red"

let winWidth = window.innerWidth;
let winHeight = window.innerHeight;
dynamicDiv.style.width = (winWidth / 5) + 'px';
dynamicDiv.style.height = (winHeight / 5) + 'px';

window.onresize = function() {
    winWidth = window.innerWidth;
    winHeight = window.innerHeight;
    dynamicDiv.style.width = (winWidth / 5) + 'px';
    dynamicDiv.style.height = (winHeight / 5) + 'px';
}

div.appendChild(dynamicDiv);

// === shopping list
const shoppingListTitle = document.createElement("h1");
shoppingListTitle.textContent = "----- Shopping list";
div.appendChild(shoppingListTitle);

// description
const desc = document.createElement("p");
desc.textContent = "Enter a new item:";
div.appendChild(desc);

// text input
const addItemInput = document.createElement("input");
addItemInput.setAttribute("type", "text");
div.appendChild(addItemInput);

// button
const addItemButton = document.createElement("button");
const ul = document.createElement("ul");

addItemButton.textContent = "Add item";
addItemButton.onclick = () => {
    const newItem = document.createElement("li");
    const deleteButton = document.createElement("button");
    deleteButton.textContent = "Delete item";
    deleteButton.onclick = () => newItem.remove();
    newItem.textContent = addItemInput.value;
    newItem.appendChild(deleteButton);
    addItemInput.value = "";
    ul.appendChild(newItem);
}

div.appendChild(addItemButton);
div.appendChild(ul);

sect.appendChild(div);

// === Fetch
const fetchTitle = document.createElement("h1");
fetchTitle.textContent = "----- Fetch pokemons";
div.appendChild(fetchTitle);


// Create an empty pokemon list
const pokemonList = document.createElement("ul");
div.appendChild(pokemonList)

// Fetch a list of 10 pokemons
fetch("https://pokeapi.co/api/v2/pokemon?limit=10&offset=20")
    .then(response => response.json()) // Wait for reply and parse to JSON once received
    .then(response => { 

        // Pokemon list response is already parsed to JSON and now it's time to use it
        console.log(response);

        var pokemons = response.results;

        pokemons.forEach(pokemon => {

            // Fetch pokemon details of each pokemon in the list
            fetch(pokemon.url) 
                .then(response => response.json()) // Wait for reply and parse to JSON once received
                .then(pokemon => {

                    // Pokemon response is already parsed to JSON and now it's time to use it
                    console.log(pokemon);
                    var sprites = pokemon.sprites;

                    // Create an <img> element and set the source
                    var pokemonImg = document.createElement("img");
                    pokemonImg.src = sprites["front_default"];

                    // Create a <li> item and set the text content to the pokemon name
                    const pokemonItem = document.createElement("li");
                    pokemonItem.textContent = pokemon["name"];

                    // Add everything to the pokemon list
                    pokemonItem.appendChild(pokemonImg);
                    pokemonList.appendChild(pokemonItem);
                })
        })
    });