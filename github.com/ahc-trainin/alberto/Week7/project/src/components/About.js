import React from 'react'

const About = () => {
  return (
    <div className="p-3 mb-2 bg-white text-dark">
      <div id="Contact" className="w-75 container-md">
        <h1 className="display-6 border-bottom">About</h1>
        <br />
        <p className="lh-sm">
          Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur
          condimentum imperdiet mauris eget condimentum. Morbi malesuada nisi ut
          augue placerat pretium. Mauris efficitur feugiat est sit amet iaculis.
          Vestibulum pretium tristique diam, sagittis consectetur neque.
          Praesent gravida purus non mollis pretium.{" "}
        </p>
        <div className="row justify-content-around">
          <div className="col-sm-3">
            <div className="card">
              <img
                src="https://images.unsplash.com/photo-1619290300995-45c343e118a8?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1744&q=80"
                className="card-img-top"
                alt="..."
              />
              <div className="card-body">
                <h5 className="card-title">John Doe</h5>
                <h6 className="card-subtitle mb-2 text-muted">CEO & founder</h6>
                <p className="card-text">
                  Some quick example text to build on the card title and make up
                  the bulk of the card's content.
                </p>
                <div className="d-grid gap-2">
                  <button className="btn btn-secondary" type="button">
                    Contact
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div className="col-sm-3">
            <div className="card">
              <img
                src="https://images.unsplash.com/photo-1516831906352-1623190ca036?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2940&q=80"
                className="card-img-top"
                alt="..."
              />
              <div className="card-body">
                <h5 className="card-title">Mike Ross</h5>
                <h6 className="card-subtitle mb-2 text-muted">Architect</h6>
                <p className="card-text">
                  Some quick example text to build on the card title and make up
                  the bulk of the card's content.
                </p>
                <div className="d-grid gap-2">
                  <button className="btn btn-secondary" type="button">
                    Contact
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div className="col-sm-3">
            <div className="card">
              <img
                src="https://images.unsplash.com/photo-1615464684446-95b73066d285?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2940&q=80"
                className="card-img-top"
                alt="..."
              />
              <div className="card-body">
                <h5 className="card-title">Jane Doe</h5>
                <h6 className="card-subtitle mb-2 text-muted">Architect</h6>
                <p className="card-text">
                  Some quick example text to build on the card title and make up
                  the bulk of the card's content.
                </p>
                <div className="d-grid gap-2">
                  <button className="btn btn-secondary" type="button">
                    Contact
                  </button>
                </div>
              </div>
            </div>
          </div>
          <div className="col-sm-3">
            <div className="card">
              <img
                src="https://images.unsplash.com/photo-1614796162029-67f2b329d16b?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2938&q=80g"
                className="card-img-top"
                alt="..."
              />
              <div className="card-body">
                <h5 className="card-title">Daniel star</h5>
                <h6 className="card-subtitle mb-2 text-muted">Architect</h6>
                <p className="card-text">
                  Some quick example text to build on the card title and make up
                  the bulk of the card's content.
                </p>
                <div className="d-grid gap-2">
                  <button className="btn btn-secondary" type="button">
                    Contact
                  </button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default About;
