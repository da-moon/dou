import Page from "./components/Page";
import "./App.css";
import pages from "./data/pages.json";
import { Component } from "react";

class App extends Component {
  constructor(props) {
    super(props);
    this.state = {
      fromPage: 0,
    };
  }

  previous = () => {
    if (this.state.fromPage === 0) {
      this.setState({fromPage: pages.length-2}) 
    } else {
      this.setState({fromPage: this.state.fromPage - 1}) 
    }
  };


  next = () => {
    if (this.state.fromPage >= pages.length-2 ) {
      this.setState({fromPage: 0}) 
    } else {
      this.setState({ fromPage: this.state.fromPage + 1 });
    }
  };

  render() {
    const page1 = pages[this.state.fromPage];
    const page2 = pages[this.state.fromPage + 1];

    return (
      <div className="Book">
        <Page
          title={page1.title}
          content={page1.content}
          footer={page1.footer}
        />

        <button type="button" className="buttonPrevious" onClick={this.previous}>
          Prev
        </button>

        <Page
          title={page2.title}
          content={page2.content}
          footer={page2.footer}
        />

        <button type="button" className="buttonNext" onClick={this.next}>
          Next
        </button>
      </div>
    );
  }
}

export default App;
