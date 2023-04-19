import "./App.css";
import { useState } from "react";

function App() {
  const DEFAULT_FORM = {
    fullName: "",
    mobile: "",
    email: "",
    gender: "male",
  };

  const [formState, setFormState] = useState(DEFAULT_FORM);
  const [formErrors, setFormErrors] = useState(DEFAULT_FORM);

  function resetFormErrors() {
    setFormErrors(DEFAULT_FORM);
  }

  function handleChange({ target: { name, value } }) {
    setFormState((prevFormState) => ({
      ...prevFormState,
      [name]: value,
    }));
  }

  function handleSubmit(event) {
    event.preventDefault();
    resetFormErrors();

    const errors = {};

    if (!formState.email) {
      errors.email = "Email is required";
    } else if (!formState.email.includes("@")) {
      errors.email = "Email don't have @";
    }

    if (!formState.mobile) {
      errors.mobile = "Mobile is required";
    } else if (formState.mobile.length !== 10) {
      errors.mobile = "Mobile needs to be 10 digits";
    }

    if (!formState.fullName) {
      errors.fullName = "Full Name is required";
    }

    if (Object.keys(errors).length) {
      setFormErrors(errors);
      return;
    }
    alert("The Information have been sent");
  }

  return (
    <section className="App">
      <div className="appBody" onSubmit={handleSubmit}>
        <div className="appHeader">
          <h1> CONTACT ME! </h1>
        </div>
        <div className="appContent">
          <div className="inputContainer">
            <label>Full Name:</label>
            <input
              type="text"
              value={formState.fullName}
              name="fullName"
              onChange={handleChange}
            />
            <div className="alertValidation">{formErrors.fullName}</div>
          </div>
          <br />
          <div className="inputContainer">
            <label>Mobile:</label>
            <input
              type="text"
              value={formState.mobile}
              name="mobile"
              onChange={handleChange}
            />
            <div className="alertValidation">{formErrors.mobile}</div>
          </div>
          <br />
          <div className="inputContainer">
            <label>Email:</label>
            <input
              type="text"
              value={formState.email}
              name="email"
              onChange={handleChange}
            />
            <div className="alertValidation">{formErrors.email}</div>
          </div>
          <br />
          <div className="inputContainer">
            <label>Gender: </label>
            <input
              type="radio"
              value="male"
              checked={formState.gender === "male"}
              name="gender"
              onChange={handleChange}
            />
            Male
            <input
              type="radio"
              value="female"
              checked={formState.gender === "female"}
              name="gender"
              onChange={handleChange}
            />
            Female
          </div>
          <button className="buttonStyle" type="submit" onClick={handleSubmit}>
            Submit
          </button>
        </div>
      </div>
    </section>
  );
}

export default App;
