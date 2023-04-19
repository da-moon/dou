import React, { useState } from "react";
import moment from "moment";
import "./Calendar.css";

const Calendar = () => {
  const [days, setDays] = useState(0);
  const [month, setMonth] = useState(moment().month());

  const prevMonth = () => {
    setMonth(month - 1);
  };

  const nextMonth = () => {
    setMonth(month + 1);
  };

  React.useEffect(() => {
    setDays(moment(`2021-${month + 1}`).daysInMonth());
  }, [month]);

  return (
    <div>
      <div className="month">
        <div className="caret careth-left" onClick={prevMonth}>
          {"<"}
        </div>
        <div className="monthName">{moment( month + 1 , 'M').format("MMMM")}</div>
        <div className="caret careth-right" onClick={nextMonth}>
          {">"}
        </div>
      </div>
      <div className="grid">
        <div className="column dayName">
          <h3>Sunday</h3>
        </div>
        <div className="column dayName">
          <h3>Monday</h3>
        </div>
        <div className="column dayName">
          <h3>Tuesday</h3>
        </div>
        <div className="column dayName">
          <h3>Wednesday</h3>
        </div>
        <div className="column dayName">
          <h3>Thursday</h3>
        </div>
        <div className="column dayName">
          <h3>Friday</h3>
        </div>
        <div className="column dayName">
          <h3>Saturday</h3>
        </div>

        {[...Array(days)].map((dayNumber, index) => {
          return (
            <div className="column day" key={index}>
              {index + 1}
            </div>
          );
        })}
      </div>
    </div>
  );
};

export default Calendar;
