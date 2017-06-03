import React from 'react'
import ProfileStar from './profileStar'

class ProfileHeader extends React.Component {
  render() {
    return (
      <div className="profile-header">
        <div className="profile-image">
          <div className={`author_image thumb_64 second ${this.props.contact.hero_pattern_classes}`}>
          </div>
        </div>
        <div className="profile-header-details">
          <div className="profile-handle">{this.props.contact.handle}</div>
          <div className="profile-phone-number">{this.props.contact.phone_number}</div>
        </div>
        <div className="profile-actions">
          <ProfileStar contact={this.props.contact} />
        </div>
      </div>
    )
  }
}

export default ProfileHeader
