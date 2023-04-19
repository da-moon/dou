import React, { useState } from "react";
import { useDispatch } from "react-redux";
import { addSkills, editSkill } from '../../redux/actions';

const Modal = ({updateSkill, closeModal, submitSkill, skillsLength}) => {
    const dispatch = useDispatch();

    const [ skillName, setSkillName ] = useState(updateSkill ? updateSkill.name : '');
    const [ comments, setComments ] = useState(updateSkill ? updateSkill.comments : '');
    const [ level, setLevel ] = useState(updateSkill ? updateSkill.level : 0);

    const resetModal = () => {
        setSkillName('');
        setComments('');
        setLevel(0);
    }

    const handleSkillChange = (event) => {
        setSkillName(event.target.value)
    }

    const handleCommentsChange = (event) => {
        setComments(event.target.value)
    }

    const handleLevelChange = (event) => {
       setLevel(Number(event.target.value));
    }

    const handleCancel = () => {
        resetModal();
        closeModal();
    }

    const handleSubmit = () => {
        const id = updateSkill ? updateSkill.id : skillName + ( skillsLength + 1); 
        const response = {
            id: id,
            name: skillName,
            level: level,
            comments: comments
        }

        if(updateSkill) {
            dispatch(editSkill(response))
        } else {
            dispatch(addSkills(response))
        }
        submitSkill();
    }

    return (
        <div className="modal-container">
                        <div className="modal-content">
                            <h3>{updateSkill ? "Edit" : "Add"} skill</h3>

                            <input className="modal-input" value={skillName} placeholder="Skill" onChange={handleSkillChange} />

                            <div className="skills-levels-container">
                                <p>Level</p>
                                <div className="skills-levels">

                                    <div>
                                        <button className={`${level === 0 ? "active" : ""}`} value={0} onClick={handleLevelChange}/>
                                        Begginer
                                    </div>

                                    <div>
                                        <button className={`${level === 1 ? "active" : ""}`} value={1} onClick={handleLevelChange}/>
                                        Elementary
                                    </div>
                                    <div>
                                        <button className={`${level === 2 ? "active" : ""}`} value={2} onClick={handleLevelChange} />
                                        Intermediate
                                    </div>
                                    <div>
                                        <button className={`${level === 3 ? "active" : ""}`} value={3} onClick={handleLevelChange} />
                                        Advanced
                                    </div>
                                </div>
                            </div>

                            <textarea 
                                value={comments} 
                                className="modal-input" 
                                placeholder="Comments"
                                onChange={handleCommentsChange}
                            >
                            </textarea>
                            <div className="modal-buttons">
                                <button className="button-cancel" onClick={handleCancel}>Cancel</button>
                                <button className="button-save" onClick={handleSubmit}>
                                    {updateSkill ? "Update" : "Save"} 
                                </button>
                            </div>
                        </div>
        </div>
    )
}

export default Modal;