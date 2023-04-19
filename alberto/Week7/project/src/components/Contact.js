import React from 'react'

const Contact = () => {

  return (
    <>
      <div className="p-3 mb-2 bg-white text-dark">
        <div id="Contact" className="w-75 container-md">
          <h1 className="display-6 border-bottom">Contact</h1>
          <br />
          <p className="lh-sm">
            Let's get in touch and talk about our next projects
          </p>
          <form id="dataForm">
            <div className="mb-3">
              <input
                type="text"
                placeholder="Name"
                className="form-control"
                id="nameInput"
                aria-describedby="nameHelp"
              />
            </div>
            <div className="mb-3">
              <input
                type="email"
                placeholder="example@email.com"
                className="form-control"
                id="emailInput"
                aria-describedby="emailHelp"
              />
              <div id="emailHelp" className="form-text">
                We'll never share your email with anyone else.
              </div>
            </div>
            <div className="mb-3">
              <input
                type="text"
                placeholder="Subject"
                className="form-control"
                id="subjectInput"
                aria-describedby="subjectHelp"
              />
            </div>
            <div className="mb-3">
              <input
                type="text"
                placeholder="Comment"
                className="form-control"
                id="commentInput"
                aria-describedby="commentHelp"
              />
            </div>
          </form>
          <button id="submitButton" className="btn btn-secondary">
            Submit
          </button>
        </div>
      </div>
    </>
  );
};

export default Contact;
