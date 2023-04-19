const counterStateInit = {
    counter: 0
}

export function counterReducer(state = counterStateInit, action) {
    switch(action.type) {
        case"increment": {
            return {...state, counter: state.counter + 1}
        }

        case"input": {
            return{...state,counter: state.counter + action.payload}
        }

        case"decrement": {
            return {...state, counter: state.counter - 1}
        }

        default: {
            return {...state}
        }
    }
}
