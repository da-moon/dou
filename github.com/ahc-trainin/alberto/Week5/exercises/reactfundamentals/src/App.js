import React, {useState,useEffect} from 'react';
import './App.css';

const SayName = ({name}) => {
  console.log('child');
  return (<section>
    <h1>Hello {name}</h1>
  </section>);
};

function App() {
  const [name , setName] = useState();

  const handleChange = ({target: {value}}) => {
    setName(value);
  };

          useEffect(() => {
        console.log('Just running one time');
    }, [])

      useEffect(() => {
        console.log('Running every time my deps(name)');
    }, [name])

  return (
    <section>
      <input type="text" value={name} onChange={handleChange} />
      <SayName name={name} />
    </section>
    );
}

export default App;
