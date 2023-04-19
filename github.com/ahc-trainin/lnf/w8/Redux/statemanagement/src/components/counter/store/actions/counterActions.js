export function counterIncrement(payload) {
    return {type: 'increment'};
}

export function counterDecrement(payload) {
    return {type: 'decrement'};
}

export function setCounter(counter){
    return {type:'input', payload: counter};
}