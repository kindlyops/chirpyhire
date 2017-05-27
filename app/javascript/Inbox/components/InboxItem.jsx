import React from 'react'

class InboxItem extends React.Component {
  href() {
    return '/messages/' + this.props.contact_id;
  }

  classNames() {
    var classes = 'InboxItem';
    if (location.pathname === this.href()) {
      classes = classes + ' active';
    }

    return classes;
  }

  render() {
    return <a href={this.href()} className={this.classNames()}>
      <div className='handle-and-timestamp'>
        <div className='handle'>
          {this.props.handle}
        </div>
        <div className='timestamp-container'>
          <div className='timestamp'>
            {this.props.timestamp}
          </div>
        </div>
      </div>
      <div className='summary'>
        {this.props.summary}
      </div>
    </a>;
  }
}

export default InboxItem
