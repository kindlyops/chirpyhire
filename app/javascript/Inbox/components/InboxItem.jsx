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
    let summary = <div className='summary-and-unread-count'>
                    <div className='summary'>
                      {this.props.summary}
                    </div>
                  </div>;

    if(this.props.unread_count > 0) {
      summary = <div className='summary-and-unread-count'>
                  <div className='summary'>
                    {this.props.summary}
                  </div>
                  <div className='badge badge-success unread-count'>
                    {this.props.unread_count}
                  </div>
                </div>
    }

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
      {summary}
    </a>;
  }
}

export default InboxItem
