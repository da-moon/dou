async function pokeApi() {

    const response = await fetch('https://pokeapi.co/api/v2/pokemon/1');
    const data = await response.json();

    console.log(data)

}

pokeApi()