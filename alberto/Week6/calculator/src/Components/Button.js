import React, { Component } from 'react'

export default class Button extends Component {
    constructor(props){
        super(props);
    }

    handleClick(){
        if(this.props.onClick){
            this.props.onClick(this.props.text);
        }
        
    }
    
    render() {
        return (            
                <button className='calc-button' onClick={() => this.handleClick()}>{this.props.text}</button>
        )
    }
}
