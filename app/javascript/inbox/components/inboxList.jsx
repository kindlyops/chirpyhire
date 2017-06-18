import React from 'react'

class InboxList extends React.Component {

  render() {
    return (
      <div className='InboxList-wrapper'>
        <div className='InboxList'>
          <span className='InboxList--Inbox'>
            <a role="button" tabIndex={0} className="InboxList--Link">
              <span className="InboxList--LinkContainer">
                <span className="InboxList--Avatar">
                  <img src="/images/medium/profile.jpeg" className="InboxList--AvatarMedia" />
                </span>
                <span>You</span>
                <span className='InboxList--Counter'>(0)</span>
              </span>
            </a>
          </span>

          <span className='InboxList--Inbox'>
            <a role="button" tabIndex={0} className="InboxList--Link selected">
              <span className="InboxList--LinkContainer">
                <span className="InboxList--Avatar">
                  <img src="/images/medium/profile.jpeg" className="InboxList--AvatarMedia" />
                </span>
                <span>New York</span>
                <span className='InboxList--Counter'>(0)</span>
              </span>
            </a>
          </span>
        </div>
      </div>
    )
  }
}

export default InboxList
