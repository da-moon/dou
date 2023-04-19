import React, { PureComponent } from 'react'
import './Page.css';

export default  class Page extends PureComponent {
    render() {
        const {title, content, footer} = this.props;
        return(
            <section className="Page">
                <main className="Main">
                    <h1>{title}</h1>
                    <hr></hr>
                    <p>{content}</p> 
                </main>
                <footer className="Footer">{footer}</footer>
            </section>
        )
    }
}   
