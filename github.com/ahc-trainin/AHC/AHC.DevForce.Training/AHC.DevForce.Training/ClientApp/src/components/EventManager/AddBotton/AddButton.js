import React from "react";
import { Link } from "react-router-dom";
import "./AddButton.css";

const AddButton = () => {
  return (
    <div className="addButton">
      <Link to="/Admin/AddEvent">
        <button type="button" className="btn btn-light">
          + Agregar Nuevo Evento
        </button>
      </Link>
    </div>
  );
};

export default AddButton;
