import React, { useRef, useEffect } from "react";
import { render } from "react-dom";

const Refs = () => {
        const ref = useRef(null);
  
        useEffect(() => {
          console.log(ref.current);
          ref.current.style = `
          background-color: red;
          height: 800px;
          width: 100%;
          `;
        }, [])
  
        return (
          <section ref={ref} style={{
            height: '200px',
            width: '200px',
      
          }}>
          </section>
          );
      }

render(<Refs />, document.getElementById("root"));

export default Refs; 