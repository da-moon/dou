import axios from "axios";
import React, { useEffect, useState } from "react";
import {
  Card,
  CardBody,
  CardTitle,
  CardSubtitle,
  CardText,
  Button,
  Container,
} from "reactstrap";
import { useParams } from "react-router-dom";
import { eventsURL } from "../../../endpoint";

import "./EventDetail.css";

const EventDetail = () => {
  const [event, setEvent] = useState([]);
  const params = useParams();

  const getEvent = async () => {
    const response = await axios.get(`${eventsURL}/${params.eventId}`);
    setEvent(response.data);
  };

  useEffect(() => {
    getEvent();
  }, []);

  return (
    <div className="main">
      <div className="header">
        <h3>Event Info</h3>
      </div>
      <Container className="bg-light border eventDetail" fluid="sm">
        <Card>
          <CardBody>
            <CardTitle tag="h5">{event.name}</CardTitle>
            <CardSubtitle>Location</CardSubtitle>
            <br></br>
            <CardText className="text-center">{event.description}</CardText>
            <h5 className="date">
              {new Date(event.date).toLocaleDateString()}
            </h5>
            <Button color="primary" className="purchase">
              Comprar
            </Button>
          </CardBody>
        </Card>
      </Container>
    </div>
  );
};

export default EventDetail;
