export const GET_SKILLS = 'GET_SKILLS';
export const GET_SKILLS_SUCCESS = 'GET_SKILLS_SUCCESS';
export const GET_SKILLS_ERROR = 'GET_SKILLS_ERROR';

export const ADD_SKILLS = 'ADD_SKILLS';
export const ADD_SKILLS_SUCCESS = 'ADD_SKILLS_SUCCESS';
export const ADD_SKILLS_ERROR = 'ADD_SKILLS_ERROR';

export const REMOVE_SKILL = 'REMOVE_SKILL';
export const REMOVE_SKILL_SUCCESS = 'REMOVE_SKILL_SUCCESS';

export const EDIT_SKILL = 'EDIT_SKILL';
export const EDIT_SKILL_SUCCESS = 'EDIT_SKILL_SUCCESS';

export const SET_SKILL = 'SET_SKILL';

export const getSkills = () => ({
    type: GET_SKILLS
});

export const getSkillsSuccess = (response) => ({
    type: GET_SKILLS_SUCCESS,
    response
});

export const getSkillsError = (error) => ({
    type: GET_SKILLS_ERROR,
    error
});

export const addSkills = (payload) => ({
    type: ADD_SKILLS,
    payload
});

export const addSkillsSuccess = (response) => ({
    type: ADD_SKILLS_SUCCESS,
    response
});

export const addSkillsError = (error) => ({
    type: ADD_SKILLS_ERROR,
    error
});

export const removeSkill = (id) => ({
    type: REMOVE_SKILL,
    id
});

export const removeSkillSuccess = (response) => ({
    type: REMOVE_SKILL_SUCCESS,
    response
});

export const editSkill = (payload) => ({
    type: EDIT_SKILL,
    payload
});

export const editSkillSuccess = (response) => ({
    type: EDIT_SKILL_SUCCESS,
    response
})

export const setSkill = (payload) => ({
    type: SET_SKILL,
    payload
})
