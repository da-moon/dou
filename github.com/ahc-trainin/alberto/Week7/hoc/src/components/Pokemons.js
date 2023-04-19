import { useEffect } from "react";
import withPokemonData from "../hocs/withPokemonData";

const Pokemons = ({ loadPage, pokemons, page, ...props }) => {
  
  useEffect(() => {
    loadPage(1);
  }, []);

  const colors = ["red", "blue", "mediumorchid", "green"];

  const randomColor = () => {
    return colors[Math.round(Math.random() * 3)];
  };

  const prevPage = () => {
    loadPage(page - 1);
  }

  const nextPage = () => {
    loadPage(page + 1);
  }

  return (
    <div className="pokemons-container container-fluid">
      {pokemons.map((pokemon, index) => (
        <div className="card border-dark m-2 poke-card" key={index}>
          <div className="card-header">pokeapi</div>
          <div className="card-body text-dark">
            <h5 className="card-title">Your pokemon is</h5>
            <div
              className="pokemons-container-item"
              style={{ backgroundColor: randomColor() }}
            >
              {pokemon.name}
            </div>
          </div>
        </div>
      ))}
      <br/>
      {props.previous ? <button className="btn btn-primary" type="button" onClick={prevPage} >prev</button> : null}
      {props.next ? <button className="btn btn-primary " type="button" onClick={nextPage}>next</button> : null}
      <br/>
    </div>
  );
};

export default withPokemonData(Pokemons);
