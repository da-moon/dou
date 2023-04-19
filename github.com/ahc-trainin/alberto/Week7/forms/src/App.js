import "./App.css";
import { useState } from "react";

function App() {
  const DEFAULT_NAME = {
    fullName: "",
    mobile: "",
    email:'',
    gender: 'male'
  };

  const [formState, setFormState] = useState(DEFAULT_NAME);

  const [FormErrors, setFormErrors] = useState(DEFAULT_NAME);
  
  const [success,setSuccess] = useState(false);

  const resetForm = () => {
    setFormErrors(DEFAULT_NAME);
  }

  const handleChange = ({ target: { name, value } }) => {
    setFormState((prevFormState) => ({
      ...prevFormState,
      [name]: value,
    }));
  };

  const handleSubmit = (event) => {
    const errors = {};
    event.preventDefault();
    resetForm();
    if(!formState.email.includes('@')){
      errors.email = 'Email needs @';
    }
    if(formState.mobile.length !== 10){
        errors.mobile= 'The number should be 10 digits';
    }
    if(!formState.fullName){
      errors.fullName= 'No name typed';
    }
    setFormErrors(errors);

    console.log(success);

    if(Object.keys(errors).length){
      setSuccess(true);
    }
    else{
      setSuccess(false);
    }

  }

  return (
    <div className="App">
      <header className="App-header">
        <div>{JSON.stringify(formState, null, 2)}</div>
        <br/>
        <label>
          Full name:
          <input
            type="text"
            value={formState.fullName}
            name="fullName"
            onChange={handleChange}
          />
          <div className='input-errors'>{FormErrors.fullName}</div>
        </label>
        <br />
        <label>
          mobile:
          <input
            type="text"
            value={formState.mobile}
            name="mobile"
            onChange={handleChange}
          />
          <div className="input-errors">{FormErrors.mobile}</div>
        </label>
        <br/>
        <label>
          email:
          <input
            type='email'
            value={formState.email}
            name="email"
            onChange={handleChange}
          />
          <div className='input-errors'>{FormErrors.email}</div>
        </label>
        <br/>
        <label>
          Gender
        </label>
        <div>
          <input type='radio' checked={ formState.gender === 'male'} value='male' name='gender' onChange={handleChange}/>
          Male
          <input type='radio' checked={ formState.gender === 'female'} value='female' name='gender' onChange={handleChange}/>
          female
        </div>
        <br/>
        <button type='submit' onClick={handleSubmit}>Submit</button>
          {success ? <p>Form submited</p> : null}
      </header>
    </div>
  );
}

export default App;
