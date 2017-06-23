import React from 'react'

class ProfileDetails extends React.Component {

  render() {
    return (
        <div className="profile-section">
          <div className="section-title profile-section-title">
            <span>Details</span>
          </div>
          <p className="profile-detail-item">
            <span className="profile-detail-category">Location:</span>
            <span className="profile-detail-value">
              <span>
                <i className={`fa fa-fw mr-1 ${this.props.contact.zipcode.icon_class}`}></i>{this.props.contact.zipcode.label}
              </span>
            </span>
          </p>
      </div>
    )
  }
}

export default ProfileDetails
