import { ofType } from 'redux-observable';
import { map, mergeMap, withLatestFrom } from 'rxjs/operators';
import {
    getSkillsSuccess,
    getSkillsError,
    addSkillsSuccess,
    removeSkillSuccess,
    editSkillSuccess,
    GET_SKILLS,
    GET_SKILLS_ERROR,
    GET_SKILLS_SUCCESS,
    ADD_SKILLS,
    ADD_SKILLS_SUCCESS,
    ADD_SKILLS_ERROR,
    REMOVE_SKILL,
    REMOVE_SKILL_SUCCESS,
    EDIT_SKILL,
    EDIT_SKILL_SUCCESS,
    SET_SKILL
} from '../actions';


const initialState = {
    skills: null,
    error: null,
    loading: false,
    skillUpdated: null
}

export const skillsData = (state = initialState, action) => {
    switch(action.type) {
        case GET_SKILLS:
            return {
                ...state,
                loading: true,
                error: null,
                skills: null,
            }
        case GET_SKILLS_SUCCESS:
            return {
                ...state,
                loading: false,
                error: null,
                skills: action.response,
            }
        case GET_SKILLS_ERROR:
            return {
                ...state,
                loading: false,
                error: action.error,
                skills: null,
            }
        case ADD_SKILLS:
            return {
                ...state,
                loading: true,
                error: null,
            }
        case ADD_SKILLS_SUCCESS:
            return {
                ...state,
                loading: false,
                error: null,
                skills: action.response
            }
        case ADD_SKILLS_ERROR:
            return {
                ...state,
                loading: false,
                error: action.error,
            }
        case REMOVE_SKILL:
            return {
                ...state,
                loading:true,
                error: null
            }
        case REMOVE_SKILL_SUCCESS:
            return {
                ...state,
                loading:false,
                skills: action.response
            }
        case EDIT_SKILL:
            return {
                ...state,
                loading:true,
                error: null
            }
        case EDIT_SKILL_SUCCESS:
            return {
                ...state,
                loading:false,
                skills: action.response
            }
        case SET_SKILL: 
            return {
                ...state,
                skillUpdated: action.payload
            }
        default:
            return {...state}
    }
}

const getSkillsData = () => {
    return new Promise((resolve, reject) => {

        setTimeout(() => {
            resolve([])
        }, 500)

        // reject({error: 'Something went wrong'})
    })
}

export const skillsDataEpic = (action$) => action$.pipe(
    ofType(GET_SKILLS),
    mergeMap(async() => {
        try {
            const response = await getSkillsData().then((response) => {
                return response;
            })
            return getSkillsSuccess(response)
        } catch(err) {
            return getSkillsError(err.error)
        }
    })
)

export const addSkillsDataEpic = (action$, state$) => action$.pipe(
    ofType(ADD_SKILLS),
    withLatestFrom(state$),
    map(([action, state]) => {
        const response = state.skillsData.skills.map((item) => {
            return item;
        });
        response.push(action.payload);

        return addSkillsSuccess(response);
    })
)

export const removeSkillDataEpic = (action$, state$) => action$.pipe(
    ofType(REMOVE_SKILL),
    withLatestFrom(state$),
    map(([action, state]) => {
        const removeSkill = state.skillsData.skills.filter((skill) => {
            return skill.id !== action.id
        })
        
        return removeSkillSuccess(removeSkill);
    })
)

export const editSkillDataEpic = (action$, state$) => action$.pipe(
    ofType(EDIT_SKILL),
    withLatestFrom(state$),
    map(([action, state]) => {
        const editSkill = state.skillsData.skills.filter((skill) => {
            return skill.id !== action.payload.id
        });
        editSkill.push(action.payload);
        
        return editSkillSuccess(editSkill);
    })
)