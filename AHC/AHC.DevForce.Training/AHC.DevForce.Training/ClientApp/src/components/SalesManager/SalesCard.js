import React from "react";
import { Card, CardTitle, CardText } from "reactstrap";

const SalesCard = (props) => {
  return (
    <Card body>
      <CardTitle tag="h5">{props.event.name}</CardTitle>
      <CardText>
        Boletos {props.tickets} comprados (costo por boleto{" "}
        {props.event.priceTicket})
      </CardText>
      <CardText>Total= {props.amount}</CardText>
    </Card>
  );
};

export default SalesCard;
