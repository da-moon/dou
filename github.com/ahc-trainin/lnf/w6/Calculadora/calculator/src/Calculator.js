import React from "react";
import Button from "./Button";

class Calculator extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      value: 0,
      history: [],
      operationClicked: false,
      currentOperation: "",
    };
  }

  handleClickNum(num) {
    let newValue = this.state.value;

    if (this.state.operationClicked === true) {
      newValue = 0;
    }

    this.setState({
      value: parseInt(newValue + num),
    });
  }

  handleClickSum() {
    this.setState({
      currentOperation: `${this.state.value} +`,
      operationClicked: true,
    });
  }

  handleClickRest() {
    this.setState({
      currentOperation: `${this.state.value} -`,
      operationClicked: true,
    });
  }

  handleClickMult() {
    this.setState({
      currentOperation: `${this.state.value} *`,
      operationClicked: true,
    });
  }

  handleClickDiv() {
    this.setState({
      currentOperation: `${this.state.value} /`,
      operationClicked: true,
    });
  }

  handleClickEqual() {
    let prevNum = parseInt(this.state.currentOperation);
    let operation =
      this.state.currentOperation[this.state.currentOperation.length - 1];
    let currentNum = this.state.value;
    let result = 0;
    let currentOperation = `${this.state.currentOperation} ${currentNum} =`;

    switch (operation) {
      case "+": {
        result = prevNum + currentNum;
        break;
      }

      case "-": {
        result = prevNum - currentNum;
        break;
      }

      case "*": {
        result = prevNum * currentNum;
        break;
      }

      case "/": {
        result = prevNum / currentNum;
        break;
      }

      default:
        break;
    }

    this.setState({
      value: result,
      currentOperation: currentOperation,
      history: [...this.state.history, `${currentOperation} ${result}`],
    });
  }

  handleClickC() {
    if (this.state.operationClicked === true) {
      this.setState({
        value: 0,
        history: [],
        currentOperation: "",
      });
    }
  }

  handleClickCE() {
    if (this.state.operationClicked === true) {
      this.setState({
        value: 0,
      });
    }
  }

  handleClickBackSpace() {
    let valueToString = this.state.value.toString();
    let newvalue = valueToString.slice(0, valueToString.length - 1);
    if (!newvalue) {
      newvalue = 0
    }
    this.setState({
      value: parseInt(newvalue),
    });
  }

  render() {
    return (
      <div className="calculator">
        <div className="subsection" id="left-subsection">
          <div className="subsection-title">
            <h3>Calculator</h3>
          </div>
          <div className="last-operation">{this.state.currentOperation}</div>
          <div className="result-view">{this.state.value}</div>
          <div className="button-container">
            <Button text="C" onClick={() => this.handleClickC()} />
            <Button text="CE" onClick={() => this.handleClickCE()} />
            <Button text="<" onClick={() => this.handleClickBackSpace()} />
            <Button text="/" onClick={() => this.handleClickDiv()} />
            <Button text="7" onClick={(num) => this.handleClickNum(num)} />
            <Button text="8" onClick={(num) => this.handleClickNum(num)} />
            <Button text="9" onClick={(num) => this.handleClickNum(num)} />
            <Button text="x" onClick={() => this.handleClickMult()} />
            <Button text="4" onClick={(num) => this.handleClickNum(num)} />
            <Button text="5" onClick={(num) => this.handleClickNum(num)} />
            <Button text="6" onClick={(num) => this.handleClickNum(num)} />
            <Button text="-" onClick={() => this.handleClickRest()} />
            <Button text="1" onClick={(num) => this.handleClickNum(num)} />
            <Button text="2" onClick={(num) => this.handleClickNum(num)} />
            <Button text="3" onClick={(num) => this.handleClickNum(num)} />
            <Button text="+" onClick={() => this.handleClickSum()} />
            <Button text="+/-" />
            <Button text="0" onClick={(num) => this.handleClickNum(num)} />
            <Button text="." />
            <Button text="=" onClick={() => this.handleClickEqual()} />
          </div>
        </div>
        <div className="subsection" id="right-subsection">
          <div className="subsection-title">
            <h3>History</h3>
          </div>
          <div className="history-container">
            {this.state.history.map((operation, idx) => (
              <p key={idx}>{operation}</p>
            ))}
          </div>
        </div>
      </div>
    );
  }
}

export default Calculator;