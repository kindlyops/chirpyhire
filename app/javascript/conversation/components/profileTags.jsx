import React from 'react'

class ProfileTags extends React.Component {

  render() {
    return (
        <div className="profile-section">
          <div className="section-title profile-section-title">
            <span>Tags</span>
          </div>
          <div className='tags d-flex'>
            {this.props.contact.tags.map(tag =>
              <div key={tag.id} className='ch-tag'>
                <i className='fa fa-tag mr-2'></i>
                {tag.name}
              </div>
            )}
          </div>
      </div>
    )
  }
}

export default ProfileTags
