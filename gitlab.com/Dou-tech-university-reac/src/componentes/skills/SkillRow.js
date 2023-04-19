import React from "react";
import { useDispatch } from "react-redux";
import { removeSkill, setSkill } from '../../redux/actions';

const SkillRow = ({rowData, editSkill}) => {
    const dispatch = useDispatch();

    const handleRemove = () => {
        dispatch(removeSkill(rowData.id))
    }

    const handleEdit = () => {
        dispatch(setSkill(rowData));
        editSkill()
    }
    return(
        <tr>
            <td>{rowData.name}</td>
            <td>{rowData.level}</td>
            <td>{rowData.comments}</td>
            <td>
                <button onClick={handleEdit}>Edit</button>
                <button onClick={handleRemove}>Remove</button>
            </td>
        </tr>
    )
}

export default SkillRow;