import React, {useState} from 'react'

const useName = (initialName = '') => {
    const [name , setName] = useState(initialName);
    console.log('child');
    const handleChange = ({target: {value}}) => {
      setName(value);
    };
    return [name, handleChange];
}

const HookExercise = () => {
    const [name, handleChange] = useName('John');
  
    console.log('parent', name);
  
    return (
        <section>
            <input type="text" value={name} onChange={handleChange} />
        </section>
    );
}

export default HookExercise;