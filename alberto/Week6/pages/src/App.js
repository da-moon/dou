import Page from './components/Page'
import './App.css';
import pages from './data/pages.json';

import React, { Component } from 'react'

export default class App extends Component {

  constructor(props){
    super(props);
    this.state = {
      page:0,
    }
  }

  handleClickBackward = () => {
    if(this.state.page === 0){
      this.setState({
        page: pages.length - 2,
      })
    } else {
      this.setState({
        page: this.state.page - 1,
      })
    }
  }

  handleClickForward = () => {
    if((this.state.page + 2) === pages.length){
      this.setState({
        page: 0,
      })
    } else {
      this.setState({
        page: this.state.page + 1,
      })
    }
  }

  render() {
    const page1 = pages[this.state.page];
    const page2 = pages[this.state.page + 1];

    console.log(this.state.page);
    console.log(this.state.page + 1);
    console.log(pages.length);

    return (
      <div className={'Book'}>
        <Page title={page1.title} content={page1.text} footer={page1.footer}/>
        <Page title={page2.title} content={page2.text} footer={page2.footer}/>
        <button className="button-previous" onClick={this.handleClickBackward}>prev</button>
        <button className="button-next" onClick={this.handleClickForward}>next</button>

      </div>
    )
  }
}

