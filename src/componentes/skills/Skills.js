import React, {useState, useEffect} from "react";
import { useDispatch, useSelector } from "react-redux";
import { SkillSelectors } from '../../redux/selectors/skillsSelectors';
import { getSkills } from '../../redux/actions';
import Modal from "./Modal";
import './Skills.css'
import SkillsTable from "./SkillsTable";

export const Skills = () => {
    const dispatch = useDispatch();
    const { selectSkills, selectSkillsError, selectSkillsLoading, selectUpdateSkill} = SkillSelectors;
    const skills = useSelector(selectSkills);
    const updateSkill = useSelector(selectUpdateSkill);
    const error = useSelector(selectSkillsError);
    const loading = useSelector(selectSkillsLoading);

    useEffect(() => {
        if(!skills) {
            dispatch(getSkills());
        }
    }, []);

    const [showModal, setShowModal] = useState(false);

    const handleModal = () => {
        setShowModal(true);
    }

    const closeModal = () => {
        setShowModal(false);
    }

    const submitSkill = () => {
        setShowModal(false);
    }

    const editSkill = () => {
        setShowModal(true);
    }

    return (
        <React.Fragment>
            <div className="skills-container">
                <button className="skills-button" onClick={handleModal}> + </button>

                { skills && skills.length > 0 ? (
                    <SkillsTable data={skills} editSkill={editSkill} />
                ) : (
                    <div>No hay resultados</div>
                )}
            </div>
            
            {
                showModal && (
                    <Modal
                        updateSkill={updateSkill}
                        closeModal={closeModal} 
                        submitSkill={submitSkill}
                        skillsLength={skills ? skills.length : 0}
                    />
                )
            }
            
        </React.Fragment>
        
    ) 
}

export default Skills;