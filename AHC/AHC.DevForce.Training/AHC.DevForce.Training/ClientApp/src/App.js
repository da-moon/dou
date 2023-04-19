import React, { Suspense } from "react";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import EventManager from "./components/EventManager/EventManager";
import LocationManager from "./components/LocationManager/LocationManager";
import AddEvent from "./components/EventManager/AddEvent/AddEvent";
import DeleteEvent from "./components/EventManager/DeleteEvent/DeleteEvent";
import EventDetail from "./components/EventManager/EventDetail/EventDetail";
import SalesManager from "./components/SalesManager/SalesManager";
import HomePage from "./components/HomePage/HomePage";
import SideBar from "./components/SideBar/SideBar";
import "./App.css";


export default class App extends React.Component {
  static displayName = App.name;

  render() {
    return (
      <Router>
        <SideBar />
        <div className="content">
          <Suspense fallback={<h1>Loading...</h1>}>
            <Switch>
              {/* RUTAS DE ADMINISTRADOR */}
              <Route path="/Admin/Events" component={EventManager} />
              <Route path="/Admin/AddEvent/:id?" component={AddEvent} />
              <Route path="/Admin/DeleteEvent/:id" component={DeleteEvent} />
              <Route path="/Admin/Locations" component={LocationManager} />
              <Route path="/Admin/Sales" component={SalesManager} />
               {/* RUTAS DE USUARIO */}
              <Route path="/" component={HomePage} />
              <Route path="EventDetail/:eventId" component={EventDetail} />
            </Switch>
          </Suspense>
        </div>
      </Router>
    );
  }
}
