import React, { Component } from "react";
import { Table } from "reactstrap";
// import "./stylesheet.css";

export default class Patients extends Component {
  constructor(props) {
    super(props);

    this.state = {
      patients: [],
    };
  }

  componentDidMount() {
    fetch("https://localhost:5001/api/patient")
      .then((response) => response.json())
      .then((results) => {
        console.log(results);
        this.setState({ patients: results });
      });
  }

  render() {

    const {patients} = this.state;

    return (
      <div className="content">
        <div className="header">
          <h1>Patients</h1>
          <p>We care for our patients, we live for them</p>
        </div>
        <div className="tablePatients">
          <Table striped>
            <thead>
              <tr>
                <th>Full Name</th>
                <th>Birth date</th>
                <th>Gender</th>
              </tr>
            </thead>
            <tbody>
              {patients.map((patient, index) => {
                return (
                  <tr key={`patient-${index}`}>
                    <td>{`${patient.firstName} ${patient.lastName}`}</td>
                    <td>{`${patient.birthDate}`}</td>
                    <td>{`${patient.gender}`}</td>
                  </tr>
                );
              })}
            </tbody>
          </Table>
        </div>
      </div>
    );
  }
}
