import { useSelector } from "react-redux";

export const User = () => {
  const counter = useSelector((store) => store.counter.counter);

  return (
    <>
      <div>This is the user component</div>
      <div>Here I'm using the counter, value: {counter} </div>
    </>
  );
};
