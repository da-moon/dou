import React, { useState } from "react";
import { render } from "react-dom";

const useName = (initialName = '') => {
  const [name , setName] = useState(initialName);
  console.log('child');
  const handleChange = ({target: {value}}) => {
    setName(value);
  };
  return [name, handleChange];
}
  
  const Hooks = () => {
  
        const [name, handleChange] = useName('John');
  
        console.log('parent', name);
  
        return (
          <section>
            <input type="text" value={name} onChange={handleChange} />
          </section>
          );
  
  }

render(<Hooks />, document.getElementById("root"));

export default Hooks; 