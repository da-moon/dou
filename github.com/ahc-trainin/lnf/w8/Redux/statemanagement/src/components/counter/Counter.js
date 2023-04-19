import React, { useState }from 'react';
import { useSelector } from "react-redux";
import { counterDecrement, counterIncrement, setCounter } from "./store/actions/counterActions";
import store from "./store/store";

export const Counter = () => {
  const [inputVal, setInputVal] = useState(0);

  const counter = useSelector (store => store.counter.counter)

  const decrement = () => {
    store.dispatch(counterDecrement())
  };

  const increment = () => {
    store.dispatch(counterIncrement())

  };

  const enter = () => {
    store.dispatch(setCounter(inputVal))
  }

  return (
    <>
      <button onClick={decrement}> - </button>
      <label>{counter}</label>
      <input onChange={(e) => setInputVal(+e.target.value)} type="number"/> <button onClick={enter} >Enter </button>
      <button onClick={increment}> + </button>
    </>
  );
};
