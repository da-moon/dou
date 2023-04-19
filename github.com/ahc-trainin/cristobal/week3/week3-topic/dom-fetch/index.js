// Write how would you combine the following 2 texts in 2 different variables 
// first has const x1 = 'Hey dude!';
// second has const x2 = 'You are awesome!';
let x1 = "Hey dude!"; 
let x2 = " You are awesome!";

console.log(x1 +  x2); 

// Write how would you destructure the following array in 3 variables [1,2,3],
// If you are exploring the following object
//	{
//		person: {
//			name: 'John',
//			age: 20
//		}
//	}

const person  = { 	firstName: 'John',
		age: 20
    	}
const {firstName, age} = person; 
console.log(firstName)
console.log(age)
console.log(person)
// Trought destructuring how do you get the name?

// Write a very simple api fetch call using async and await
const pokemonInfo = []

async function fetchPokemon(pokemonId) {  
    let response = fetch('https://pokeapi.co/api/v2/pokemon/6').toString();
    let poke = await response.json()
    pokemonInfo.push(poke)
   }

   console.log(pokemonInfo)