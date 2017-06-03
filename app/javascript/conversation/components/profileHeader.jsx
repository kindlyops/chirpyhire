import React from 'react'

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
          <div className="profile-star">
            <form className="button_to" method="post" action={`/contacts/${this.props.contact.id}/star`}>
              <button className="star btn btn-link" role="button" data-toggle="tooltip" data-placement="left" title="Unstar caregiver">
                <i className="fa fa-star"></i>
              </button>
              <input type="hidden" name="authenticity_token" value="3oD+nHijL2aBwD7P7H3cIBB474ZlMiaY+012XtOkAp9BYFgvXa1ljBp/PCHI7j+k6Kr0kt75W8+1ij8/86SRNQ==" />
            </form>
          </div>
        </div>
      </div>
    )
  }
}

export default ProfileHeader
