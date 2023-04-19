import React from "react";
import "./Page.css";

class Page extends React.PureComponent {
  render() {
    const { title, content, footer } = this.props;

    return (
      <section className="Page">
        <header className="page-header">
          <h1>{title}</h1>
          </header>
          <article className="page-content">
        <p> {content}</p>
        </article>
        <footer className="page-footer">
        <p>{footer}</p>
        </footer>
      </section>
    );
  }
}

export default Page;
