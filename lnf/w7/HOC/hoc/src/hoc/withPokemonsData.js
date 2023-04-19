import { useState } from "react";

const LIMIT = 41;
const API_URL = 'http://pokeapi.co/api/v2/pokemon';

const withPokemonsData = (Child) => {

    return () => {

        const [pokemons, setPokemons] = useState([]);
        const [page, setPage] = useState(1);
        const [count, setCount] = useState(1);

        const loadPage = async (page = 1) => {
            const fetchRes = await fetch(`${API_URL}?limit=${LIMIT}&offset=${LIMIT * (page - 1)}`);
            const jsonRes = await fetchRes.json();
            setCount (jsonRes.count);
            setPage(page);
            setPokemons(jsonRes.results);
        };

        return <Child loadPage={loadPage} pokemons={pokemons} page={page} count={count}/>
    }
  
    
}

export default withPokemonsData;