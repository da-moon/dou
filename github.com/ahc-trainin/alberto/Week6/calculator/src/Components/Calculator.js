import React, { Component } from 'react'
import Button from './Button';

export default class Calculator extends Component {
    
    constructor(props){
        super(props);
        this.state = {
            value: 0,
            history: [],
            currentOperation: "",
            finalResult: false,
            positive: true,
        }
    }

    handleClickNum(num){
        if (this.state.finalResult === true){
            this.setState({
                value:0,
                finalResult: false,
            })
        }
        let newValue = this.state.value;
        this.setState({
            value: parseInt(newValue + num),
        });
    }

    handleClickOperation(operator){
        this.setState({
            currentOperation: `${this.state.value} ${operator}`,
            value: 0,
            operationClicked: true,
        })
    }

    handleCE(){
        this.setState({
            value: 0,
        })
    }

    handleClear(){
        this.setState({
            value: 0,
            history: [],
            currentOperation: "",
            finalResult: false,
        })
    }

    handlePositiveNegative(){
        if (this.state.positive === true){
            this.setState({
                value: parseInt(`-${this.state.value}`),
                positive: false,
            })
        } else {
            let current = this.state.value.toString();
            this.setState({
                value: current.substring(1,current.length),
                positive: true
            })
        }
    }

    handleBack(){
        let value = this.state.value.toString();
        this.setState({
            value: parseInt(value.substring(0, value.length-1)),
        })
    }

    handleClickEqual(){
        let prevNum = parseInt(this.state.currentOperation);
        let operation = this.state.currentOperation[this.state.currentOperation.length - 1];
        let currentNum = this.state.value;
        let result = 0;
        let currentOperation = `${this.state.currentOperation} ${currentNum} =`;
        
        switch(operation){
            case '+': {
                result = prevNum + currentNum;
                break;
            }
            case '-': {
                result = prevNum - currentNum;
                break;
            } 
            case 'x': {
                result = prevNum * currentNum;
                break;
            } 
            case '÷': {
                result = prevNum / currentNum;
                break;
            } 
            default: break;
        }

        this.setState({
            value: result,
            currentOperation: currentOperation,
            history: [...this.state.history,`${currentOperation} ${result}`],
            finalResult: true,
        });
    }
    
    render() {
        return (
            <div>
                <div className="calculator">
                    <div className="subsection" id="left-subsection">
                        <div className="subsection-title">
                            <h3>Calculator</h3>
                        </div>

                        <div className="last-operation">
                            {this.state.currentOperation}
                        </div>

                        <div className="result-view">
                            {this.state.value}
                        </div>

                        <div className="button-container">     
                            <Button text='CE' onClick={() => this.handleCE()}/>
                            <Button text='C' onClick={() => this.handleClear()} />
                            <Button text='←' onClick={() => this.handleBack()} />
                            <Button text='÷' onClick={() => this.handleClickOperation('÷')}/>
                            <Button text='7' onClick={(num) => this.handleClickNum(num)}/>     
                            <Button text='8' onClick={(num) => this.handleClickNum(num)}/>
                            <Button text='9' onClick={(num) => this.handleClickNum(num)}/>
                            <Button text='x' onClick={() => this.handleClickOperation('x')}/>
                            <Button text='4' onClick={(num) => this.handleClickNum(num)}/>     
                            <Button text='5' onClick={(num) => this.handleClickNum(num)}/>     
                            <Button text='6' onClick={(num) => this.handleClickNum(num)}/>
                            <Button text='-' onClick={() => this.handleClickOperation('-')}/>
                            <Button text='1' onClick={(num) => this.handleClickNum(num)}/>     
                            <Button text='2' onClick={(num) => this.handleClickNum(num)}/>     
                            <Button text='3' onClick={(num) => this.handleClickNum(num)}/>
                            <Button text='+' onClick={() => this.handleClickOperation('+')}/>
                            <Button text='+/-' onClick={() => this.handlePositiveNegative()} />
                            <Button text='0' onClick={(num) => this.handleClickNum(num)}/>
                            <Button text='.'/>
                            <Button text='=' onClick={() => this.handleClickEqual()}/>
                        </div>

                    </div>

                    <div className="subsection" id="right-subsection">
                        <div className="subsection-title">
                            <h3>History</h3>
                        </div>
                        <div className="history-container">
                            {this.state.history.map( (operation) => 
                                <p>{operation}</p>
                            )}
                        </div>
                    </div>
                </div>
            </div>
        )
    }
}
