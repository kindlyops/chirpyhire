import React from 'react'

class ProfileStar extends React.Component {
  iconClasses() {
    if (this.props.contact.starred) {
      return 'fa fa-star';
    } else {
      return 'fa fa-star-o';
    }
  }

  title() {
    if (this.props.contact.starred) {
      return 'Unstar caregiver';
    } else {
      return 'Star caregiver';
    }
  }

  render() {
    return (
      <div className="profile-star">
        <form className="button_to" data-remote="true" method="post" action={`/contacts/${this.props.contact.id}/star`}>
          <button className="star btn btn-link" role="button">
            <i className={this.iconClasses()}></i>
          </button>
        </form>
      </div>
    )
  }
}

export default ProfileStar
