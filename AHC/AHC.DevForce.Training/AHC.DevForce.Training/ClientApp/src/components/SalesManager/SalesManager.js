import axios from "axios";
import React, { useEffect, useState } from "react";
import { salesURL } from "../../endpoint";
import SalesCard from "./SalesCard";

const SalesManager = () => {
  const [sales, setSales] = useState([]);

  const getSales = async () => {
    const response = await axios.get(`${salesURL}/user/1`);
    setSales(response.data);
  };

  useEffect(() => {
    getSales();
  }, []);

  return (
    <div>
      {sales.map((sale, index) => (
        <SalesCard key={index} {...sale} />
      ))}
    </div>
  );
};

export default SalesManager;
