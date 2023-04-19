import React from "react";

function PokemonInfo(props) {
    const { pokemon } = props;

    if (!pokemon) {
        return "Please select a pokemon from the left panel";
    }

    return (
        <div>
            <h1>{pokemon.name} ({pokemon.id})</h1>
            <p>Weight: {pokemon.weight}</p>
            <p>Height: {pokemon.height}</p>

            <h2>Sprites</h2>
            <table>
                <thead>
                    {
                        Object.entries(pokemon.sprites)
                            .filter(([spriteSide]) => spriteSide !== "other" && spriteSide !== "versions")
                            .map(([spriteSide]) => <th>{spriteSide}</th>)}
                </thead>
                <tbody>
                    <tr>
                        { 
                            Object.entries(pokemon.sprites)
                                .filter(([spriteSide]) => spriteSide !== "other" && spriteSide !== "versions")
                                .map(([spriteSide, imgSrc]) => <td><img src={imgSrc} /></td>)}
                    </tr>
                </tbody>
            </table>
        </div>
    )

}

export default PokemonInfo;