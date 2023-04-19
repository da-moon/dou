import { useState, useEffect } from "react";

function usePokemon(pokemonName) {
    const [pokemon, setPokemon] = useState(null);

    useEffect(() => {
        if (pokemonName !== null) {
            fetch(`https://pokeapi.co/api/v2/pokemon/${pokemonName.toLowerCase()}`)
                .then(res => res.json())
                .then(pokemon => setPokemon(pokemon))
                .catch(err => console.log(err));
        }
    }, [pokemonName])

    return pokemon;
}

export default usePokemon;