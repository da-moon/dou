import React from "react";
import usePokemon from "../hooks/usePokemons";

function MenuItem(props) {
    
    const pokemon = usePokemon(props.text);

    return (
        <li className="menu-item" onClick={() => props.onClick(pokemon) }>
            {pokemon && <img src={pokemon.sprites["front_default"]} /> }
            {props.text} Hola
        </li>
    )
}

export default MenuItem;