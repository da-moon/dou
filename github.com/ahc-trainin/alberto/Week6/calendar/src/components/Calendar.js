import React, {useState, useEffect} from 'react';
import './Calendar.css';
import moment from 'moment';

const Calendar = () => {

    const [days, setDays] = useState(0);

    const [month, setMonth] = useState(moment().month());

    let year = 2021;

    const prevMonth = () => {
        if (month === 0 ){
            setMonth(11);
            year--;
        } else {
            setMonth(month - 1);
        }
    }

    const nextMonth = () => {
        if (month === 11 ){
            setMonth(0);
        } else {
            setMonth(month + 1);
        }
    }

    useEffect(() => {
        setDays(moment(`2021-${month + 1}`).daysInMonth());
    }, [month]);

    return (
        <>
            <div className='header'>
                <div className="caret-left" onClick={prevMonth}>{'<'}</div>
                <h2 className="month">{moment(month + 1, 'M').format('MMMM')}</h2>
                <div className="caret-right" onClick={nextMonth}>{'>'}</div>
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
                {[...Array(days)].map((day, index) => {
                    return (
                        <div key={index} className="column day">
                            {index + 1}
                        </div>
                    )
                })}
            </div>

        </>
        
    )
}

export default Calendar
