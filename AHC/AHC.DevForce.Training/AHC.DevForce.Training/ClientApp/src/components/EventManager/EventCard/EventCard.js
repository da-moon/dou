import React from "react";
import { useHistory } from "react-router-dom";
import locationIcon from "../icons/Location.png";
import editIcon from "../icons/Edit.png";
import deleteIcon from "../icons/Delete.png";
import "./EventCard.css";
import { NavLink } from "reactstrap";

const EventCard = (props) => {
  const history = useHistory();
  const id = props.id;
  const handleDeleteClick = () => history.push(`/Admin/DeleteEvent/${id}`);
  const handleEditClick = () => history.push(`/Admin/AddEvent/${id}`);
  const handleDetailClick = () => history.push(`/Admin/EventDetail/${id}`);

  return (
    <div className="eventCard">
      <div className="generalInformation">
        <h1 className="eventName">
          <NavLink href="#" onClick={handleDetailClick}>
            {props.name}
          </NavLink>
        </h1>
        <p className="eventDescription">{props.description}</p>
        <div className="date">
          <p>{new Date(props.date).toLocaleDateString()}</p>
        </div>
        <div className="location">
          <img src={locationIcon} alt="location" />
          <p>{props.location.address}</p>
        </div>
      </div>
      <div className="rightSide">
        <div className="delete">
          <img src={deleteIcon} onClick={handleDeleteClick} alt="delete" />
        </div>
        <div className="price">
          <h1>{`$ ${props.priceTicket}`}</h1>
        </div>
        <div className="editar">
          <button onClick={handleEditClick}>Editar </button>
          <img src={editIcon} alt="edit" />
        </div>
      </div>
    </div>
  );
};

export default EventCard;
