import { combineReducers, createStore } from 'redux';
import { counterReducer } from './reducers/counterReducer';

//reducers

const rootReducer = combineReducers({
    counter: counterReducer,
});

const store = createStore(
    rootReducer,
    window.__REDUX_DEVTOOLS_EXTENSION__ && window.__REDUX_DEVTOOLS_EXTENSION__()
);

export default store;