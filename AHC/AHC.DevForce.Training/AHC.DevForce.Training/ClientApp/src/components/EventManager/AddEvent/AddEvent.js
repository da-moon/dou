import React, { useEffect, useState } from 'react';
import { useHistory } from 'react-router-dom';
import './AddEvent.css';

const AddEvent = (props) => {

    const id = props.match.params.id;

    const isEdit = (id !== undefined);

    const [event, setEvent] = useState({});

    useEffect(() => {
        if (isEdit) {
            fetch(`/api/events/${id}`)
                .then(response => response.json())
                .then(data => {
                    setEvent(data);
                })
        }

    }, [])

    const handleOnChange = (e) => {
        const inputValue = e.target.value;
        setEvent({ ...event, [e.target.name]: inputValue })
    }

    const history = useHistory();

    const onClick = (e) => {
        e.preventDefault();

        fetch('/api/events',
            {
                method: isEdit ? 'PUT' : 'POST',
                headers: {
                    'Accept': 'application/json',
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify({ ...event, locationId: 5, date: new Date(),  priceTicket: parseInt(event.priceTicket) })
            })
            .then(response => response.json())
            .then(data => {
                if (data) {
                    history.push('/Admin/Events');
                } else {
                    alert("Something is wrong");
                }
            })
    }

    return (
        <div className="addScreen">
            <div className="addCard">
                <form>
                    <div className="form-group">
                        <label htmlFor="exampleInputEvento">Evento:</label>
                        <input type="text" className="form-control" onChange={handleOnChange}
                            value={event.name || ""} id="exampleInputEvento" required name="name" placeholder="Evento" />
                    </div>
                    <div className="form-group">
                        <label htmlFor="exampleInputDescripción">Descripción:</label>
                        <textarea type="text" className="form-control" onChange={handleOnChange}
                            value={event.description || ""} id="exampleInputDescripción" required name="description" rows="5" placeholder="Descripción"></textarea>
                    </div>
                    <div className="form-group">
                        <label htmlFor="exampleInputPrecio">Precio:</label>
                        <input type="number" className="form-control" onChange={handleOnChange}
                            value={event.priceTicket || ""} id="exampleInputPrecio" required
                            name="priceTicket" placeholder="Precio" />
                    </div>
                    <select className="form-select" aria-label="Default select example" placeholder='Selecciona un Lugar'>
                        <option value="1">Lugar 1</option>
                        <option value="2">Lugar 2</option>
                        <option value="3">Lugar 3</option>
                    </select>
                    <div className="formButton">
                        <button type="button" onClick={onClick} className="btn btn-primary btn-lg btn-block">Guardar</button>
                    </div>
                </form>
            </div>
        </div>
    )
}

export default AddEvent
