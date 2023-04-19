import MenuItem from "./components/MenuItem"
import './App.css';
import PokemonInfo from "./components/PokemonInfo";
import { useEffect, useState } from "react";
import usePokemon from "./hooks/usePokemons";

function App() {
  const moltres = usePokemon("moltres");
  const zapdos = usePokemon("zapdos");

  const [selectedPokemon, setSelectedPokemon] = useState(null);
  const [clickCount, setClickCount] = useState(0);

  const onMenuItemClick = (pokemon) => {
    setSelectedPokemon(pokemon);
    setClickCount(clickCount + 1);
  }

  // do something after `clickCount` changes
  useEffect(() => {
    document.title = `Pokemon App. ${clickCount} pokemons seen`;

    if (clickCount === 4) {
      alert("Congrats! You have clicked on all pokemons!");
    }
  }, [clickCount])
  
  // do something just once (onComponentDidMount)
  useEffect(() => {
    alert("Hi, welcome to the pokemon app!");
  }, [])

  return (
    <div>
      <header className="header">
        { moltres && <img src={moltres.sprites["front_default"]} style={{ height: "50px"}} />}
        Pokemon App
      </header>

      <div className="app">
        <div className="side-menu">
          <ul>
            <MenuItem text="Pikachu" onClick={onMenuItemClick} />
            <MenuItem text="Mewtwo" onClick={onMenuItemClick} />
            <MenuItem text="Machamp" onClick={onMenuItemClick} />
            <MenuItem text="Sandslash" onClick={onMenuItemClick} />
          </ul>
        </div>

        <div className="main-content">
          <PokemonInfo pokemon={selectedPokemon} />
        </div>
      </div>

      <footer className="footer">
        { zapdos && <img src={zapdos.sprites["front_default"]} style={{ height: "50px"}} />}
        Pokemon App. All rights reserved
      </footer>

    </div>
  );
}

export default App;
