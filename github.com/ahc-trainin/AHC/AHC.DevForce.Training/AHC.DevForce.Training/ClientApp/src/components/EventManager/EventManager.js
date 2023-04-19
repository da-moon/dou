import React, { useState, useEffect } from "react";
import axios from "axios";
import "../EventManager/EventManager.css";
import AddButton from "./AddBotton/AddButton";
import EventCard from "./EventCard/EventCard";
import { eventsURL } from "../../endpoint";

const EventManager = () => {
  const [events, setEvents] = useState([]);

  const getEvents = async () => {
    const response = await axios.get(eventsURL);
    setEvents(response.data);
  };

  useEffect(() => {
    getEvents();
  }, []);

  return (
    <div className="contentContainer">
      <div className="add">
        <AddButton />
      </div>
      <div className="cardEvent">
        {events.map((evt, index) => (
          <EventCard key={index} {...evt} />
        ))}
      </div>
    </div>
  );
};

export default EventManager;
