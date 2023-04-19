import { useEffect } from "react";
import withPokemonsData from "../hoc/withPokemonsData";
import "./Pokemons.css";
import logo from "../imgs/logo.png";

const colorPallet = ["#3d7dca", "#003A70", "#FFCB05", "#c7a008"];

const Pokemon = ({ loadPage, pokemons, page, count }) => {
  useEffect(() => {
    loadPage(1);
  }, []);

  const handleClickNext = () => {
    loadPage(page + 1);
  }

  const handleClickPrev = () => {
    loadPage(page - 1);
  }

  const getRandomColor = () => {
    const colors = Math.round(Math.random() * 3);
    return colorPallet[colors];
  };

  return (
    <div className="pokemon-container">
      <img src={logo} />
      <div className="pokemon-card">
        {pokemons.map((pokemon) => (
          <div
            className="pokemon-card-item"
            style={{ backgroundColor: getRandomColor() }}
          >
            {pokemon.name}
          </div>
        ))}
        { page === 1 ? null : <button onClick={handleClickPrev} className="prev-button"> PREV <br/> ⇦ </button>}
        { pokemons.length === count ? null : <button onClick={handleClickNext} className="next-button"> NEXT <br/> ⇨ </button>} 
      </div>
    </div>
  );
};

export default withPokemonsData(Pokemon);
