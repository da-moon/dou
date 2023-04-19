import React from 'react';
import Trash from '../img/Trash.png';
import { Link, useHistory } from 'react-router-dom';
import './DeleteEvent.css';

const DeleteEvent = (props) => {

    const history = useHistory();

    const deleteConfirm = () => {
        fetch (`/api/events/${props.match.params.id}`,
        { method: 'DELETE',})
        .then(response => response.json())
        .then(data => {

            if (data) {
                
                history.push('/Admin/Events');
            }
        })
    }

    return (
        <div className="deleteScreen">
            <div className="deleteCard">
                    <div className="deleteQuestion">
                        <img src={Trash} alt="location" className="imgTrash"/>
                        <p className="question">Seguro que deseas <br /> borrar este registro?</p>
                    </div>
                    <div className="deleteButtons">
                        <button type="button" className="btn btn-success" onClick={deleteConfirm}>Confirmar</button>
                    <Link to="/Admin/Events">
                        <button type="button" className="btn btn-dark">En otro momento...</button>
                    </Link>
                    </div>
            </div>
        </div>
    )
}

export default DeleteEvent
