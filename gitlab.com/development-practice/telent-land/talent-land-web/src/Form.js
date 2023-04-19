import React, { useState } from "react";
import logo from "./image/logo.png";
import Swal from "sweetalert2";
import "./Form.css";

const Form = () => {
  const [username, setUsername] = useState("");
  const [email, setEmail] = useState("");
  const [contact, setContact] = useState("");
  const [linkedin, setlinkedin] = useState("");
  const [skills, setSkills] = useState("");
  const [yearsOfExperience, setYearsOfExperience] = useState("");
  const [englishLevel, setEnglishLevel] = useState("");


  const formHandler = (e) => {
    e.preventDefault();

    let special_characters = ["$", "%", "^", "&", "*", "(", ")", "@"];
    let re = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/im;

    if (
      username.trim() === "" ||
      email.trim() === "" ||
      contact.trim() === "" ||
      skills.trim() === "" ||
      yearsOfExperience.trim() === "" ||
      englishLevel.trim() === ""
    ) {
      return Swal.fire({
        title: "Error!",
        text: "Please enter required (*) information",
        icon: "error",
        confirmButtonText: "Return",
      });
    }

    //name validation
    let str_name = username.split("");

    if (username.match(/\d/)) {
      return Swal.fire({
        title: "Error!",
        text: "Please enter valid name.",
        icon: "error",
        confirmButtonText: "Return",
      });
    }

    if (str_name.find((item) => special_characters.includes(item))) {
      return Swal.fire({
        title: "Error!",
        text: "Please enter valid name.",
        icon: "error",
        confirmButtonText: "Return",
      });
    }
    //phone validator
    const phoneNumberValidation = re.test(+contact);

    if (!phoneNumberValidation) {
      return Swal.fire({
        title: "Error!",
        text: "Please enter valid phone number.",
        icon: "error",
        confirmButtonText: "Return",
      });
    }
    const info = {
      name: username,
      email: email,
      contactNumber: contact,
      linkedIn: linkedin,
      skills: skills,
      yearsOfExperience: yearsOfExperience,
      englishLevel: englishLevel
    };

    async function addUserHandler() {
      const response = await fetch(
        "https://api.landpage.techmcne.com/join-us/candidates",
        {
          method: "POST",
          body: JSON.stringify(info),
          headers: { "Content-Type": "application/json" },
        }
      );

      if (response.status === 200 || response.status === 201) {
        Swal.fire({
          title: "Sucess!",
          text: "Registered Successfully",
          icon: "success",
          confirmButtonText: "Sucess",
        });
        setUsername("");
        setEmail("");
        setContact("");
        setlinkedin("");
        setSkills("");
        setYearsOfExperience("");
        setEnglishLevel("");

        window.location.href = "https://digitalonus.com/join-us/";
      }

      if (response.status !== 200 && response.status !== 201) {
        Swal.fire({
          title: "Warning!",
          text: "Already registered with this email",
          icon: "warning",
          confirmButtonText: "Return",
        });
      }
    }
    addUserHandler();
  };
  return (
    <>
      <div className="form">
        <form className="form-items" onSubmit={formHandler}>
          <span>Be part of</span>
          <h1>OUR TEAM</h1>
          <div className="transparent">
            <div className="form-item">
              <input
                placeholder="Name *"
                type="text"
                name="username"
                className="input-field"
                onChange={(e) => setUsername(e.target.value)}
                value={username}
              />
            </div>
            <div>
              <input
                placeholder="Email *"
                type="email"
                name="email"
                className="input-field"
                onChange={(e) => setEmail(e.target.value)}
                value={email}
              />
            </div>
            <div>
              <input
                placeholder="Contact Number *"
                type="number"
                name="contact"
                className="input-field"
                onChange={(e) => setContact(e.target.value)}
                value={contact}
              />
            </div>
            <div>
              <input
                placeholder="LinkedIn (optional)"
                type="text"
                name="linkedin"
                className="input-field"
                onChange={(e) => setlinkedin(e.target.value)}
                value={linkedin}
              />
            </div>
            <div>
              <input
                placeholder="Skills * (Python, HTML, CSS, etc)"
                type="text"
                name="skills"
                className="input-field"
                onChange={(e) => setSkills(e.target.value)}
                value={skills}
              />
            </div>
            <div>
              <input
                placeholder="Years of Experience *"
                type="number"
                name="yearsOfExperience"
                min="0"
                max="99"
                className="input-field"
                onChange={(e) => setYearsOfExperience(e.target.value)}
                value={yearsOfExperience}
              />
            </div>
            <div>

              <select
                className="input-field"
                onChange={(e) => setEnglishLevel(e.target.value)}
                defaultValue={""}
              >
                <option value="" disabled>English Level *</option>

                <option value="junior">Junior (0-40%)</option>

                <option value="midlevel">Mid-level (50-70%)
                </option>

                <option value="advanced">Advanced (Conversational English)

                </option>
              </select>
            </div>
          </div>

          <button className="button">JOIN US</button>
          {/* <div className="link">
          Find exciting opportunities by{" "}
          <span>
            <a
              href="https://digitalonus.com/join-us/"
              target="_blank"
              rel="noreferrer"
            >
              Joining Us!
            </a>
          </span>{" "}
          now
        </div> */}
        </form>
      </div>
      <img src={logo} alt="Tech Mahindra" className="logo" />
    </>
  );
};

export default Form;
