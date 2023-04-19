import { useState } from "react";

const LIMIT = 40;
const API = "https://pokeapi.co/api/v2/pokemon";

const withPokemonData = (Child) => {
  return () => {
    const [pokemons, setPokemons] = useState([]);
    const [page, setPage] = useState(1);
    const [next, setNext] = useState(false);
    const [previous,setPrevious] = useState(false)

    const loadPokemons = async (page = 1) => {
      const fetchRes = await fetch(
        `${API}?limit=${LIMIT}&offset=${LIMIT * (page - 1)}`
      );
      const response = await fetchRes.json();
      setPage(page);
      setPokemons(response.results);
      if (response.next){
        setNext(true);
      } else setNext(false);
      if (response.previous){
        setPrevious(true)
      } else setPrevious(false);
    };

    return <Child loadPage={loadPokemons} pokemons={pokemons} page={page} next={next} previous={previous} />;
  };
};

export default withPokemonData;
