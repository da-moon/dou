import React from "react";
import SkillRow from "./SkillRow";


const SkillsTable = ({data, editSkill}) => {
    const skillsRows = data.map((row) => {
        return <SkillRow key={row.id} rowData={row} editSkill={editSkill} />
    })
    return (
        <table className="skills-data" cellPadding={0} cellSpacing={0}>
            <thead>
                <tr>
                    <td>Skill</td>
                    <td>Level</td>
                    <td>Comments</td>
                    <td></td>
                </tr>
            </thead>
            <tbody>
                {
                    skillsRows
                }
            </tbody>
        </table>
    )
}

export default SkillsTable;