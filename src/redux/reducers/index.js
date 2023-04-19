import { combineReducers } from "redux";
import { combineEpics } from "redux-observable";

import { skillsData, skillsDataEpic, addSkillsDataEpic, removeSkillDataEpic, editSkillDataEpic } from '../reducers/skills';

export const reducers = combineReducers({skillsData});
export const epics = combineEpics(skillsDataEpic, addSkillsDataEpic, removeSkillDataEpic, editSkillDataEpic);