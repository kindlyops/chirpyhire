import React from 'react'

class ProfileDetails extends React.Component {
  render() {
    return (
        <div className="profile-details">
          <div className="section-title profile-section-title">
            <span>Details</span>
          <div className="profile-main-filters">
            <a data-toggle="tooltip" data-placement="left" className="profile-near-filter" href={`/caregivers?availability%5B%5D=${encodeURIComponent(this.props.contact.availability.query)}&amp;availability%5B%5D=${encodeURIComponent(this.props.contact.live_in.query)}&amp;certification%5B%5D=${encodeURIComponent(this.props.contact.certification.query)}&amp;experience%5B%5D=${encodeURIComponent(this.props.contact.experience.query)}&amp;transportation%5B%5D=${encodeURIComponent(this.props.contact.transportation.query)}&amp;zipcode=${encodeURIComponent(this.props.contact.zipcode.label)}`} title="View nearly identical caregivers.">
              <i className="fa fa-fw fa-bullseye mr-1"></i>
              Near
            </a>
            <a data-toggle="tooltip" data-placement="left" className="profile-broad-filter" href={`/caregivers?certification%5B%5D=${encodeURIComponent(this.props.contact.certification.query)}&amp;zipcode=${encodeURIComponent(this.props.contact.zipcode.label)}`} title="View broadly similar caregivers.">
              <i className="fa fa-fw fa-dot-circle-o mr-1"></i>
              Broad
            </a>
          </div>
        </div>
        <p className="profile-detail-item">
          <span className="profile-detail-category">Location:</span>
          <span className="profile-detail-value">
            <a data-toggle="tooltip" data-placement="left" href={`/caregivers?zipcode=${encodeURIComponent(this.props.contact.zipcode.label)}`} title={this.props.contact.zipcode.tooltip_label}>
              <i className={`fa fa-fw mr-1 ${this.props.contact.zipcode.icon_class}`}></i>{this.props.contact.zipcode.label}
            </a>
          </span>
        </p>
        <p className="profile-detail-item">
          <span className="profile-detail-category">Certification:</span>
          <span className="profile-detail-value">
            <a data-toggle="tooltip" data-placement="left" href={`/caregivers?certification%5B%5D=${encodeURIComponent(this.props.contact.certification.query)}`} title={this.props.contact.certification.tooltip_label}>
              <i className={`fa fa-fw mr-1 ${this.props.contact.certification.icon_class}`}></i>
              {this.props.contact.certification.label}
            </a>
          </span>
        </p>
        <p className="profile-detail-item">
          <span className="profile-detail-category">Availability:</span>
          <span className="profile-detail-value availability">
            <span className="profile-detail-subvalue">
              <a data-toggle="tooltip" data-placement="left" href={`/caregivers?availability%5B%5D=${encodeURIComponent(this.props.contact.availability.query)}`} title={this.props.contact.availability.tooltip_label}>
                <i className={`fa fa-fw mr-1 ${this.props.contact.availability.icon_class}`}></i>
                {this.props.contact.availability.label}
              </a>
            </span>
            <span className="profile-detail-subvalue">
              <a data-toggle="tooltip" data-placement="left" href={`/caregivers?availability%5B%5D=${encodeURIComponent(this.props.contact.live_in.query)}`} title={this.props.contact.live_in.tooltip_label}>
                <i className={`fa fa-fw mr-1 ${this.props.contact.live_in.icon_class}`}></i>
                {this.props.contact.live_in.label}
              </a>
            </span>
          </span>
        </p>
        <p className="profile-detail-item">
          <span className="profile-detail-category">Experience:</span>
          <span className="profile-detail-value">
            <a data-toggle="tooltip" data-placement="left" href={`/caregivers?experience%5B%5D=${encodeURIComponent(this.props.contact.experience.query)}`} title={this.props.contact.experience.tooltip_label}>
              <i className={`fa fa-fw mr-1 ${this.props.contact.experience.icon_class}`}></i>
              {this.props.contact.experience.label}
            </a>
          </span>
        </p>
        <p className="profile-detail-item">
          <span className="profile-detail-category">Transportation:</span>
          <span className="profile-detail-value">
            <a data-toggle="tooltip" data-placement="left" href={`/caregivers?transportation%5B%5D=${encodeURIComponent(this.props.contact.transportation.query)}`} title={this.props.contact.transportation.tooltip_label}>
              <i className={`fa fa-fw mr-1 ${this.props.contact.transportation.icon_class}`}></i>
              {this.props.contact.transportation.label}
            </a>
          </span>
        </p>
        <p className="profile-detail-item">
          <span className="profile-detail-category">CPR / 1st Aid:</span>
          <span className="profile-detail-value">
            <i className={`fa fa-fw mr-1 ${this.props.contact.cpr_first_aid.icon_class}`}></i>
            {this.props.contact.cpr_first_aid.label}
          </span>
        </p>
        <p className="profile-detail-item">
          <span className="profile-detail-category">Skin / TB Test:</span>
          <span className="profile-detail-value">
            <i className={`fa fa-fw mr-1 ${this.props.contact.skin_test.icon_class}`}></i>
            {this.props.contact.skin_test.label}
          </span>
        </p>
      </div>
    )
  }
}

export default ProfileDetails
