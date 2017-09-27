import React from 'react'

class ProfileSource extends React.Component {
  constructor(props) {
    super(props);
    this.onChange = this.onChange.bind(this);
  }

  onChange(event) {
    this.props.onSourceChange(event);
  }

  render() {
    return (
      <div className='form-group'>
        <label id='source' className='col-form-label'><strong>Source:</strong></label>
        <input id='source' className='form-control' placeholder='CraigsList, Facebook, Referral...' type="text" name="contact[source]" value={this.props.source} onChange={this.onChange} />
      </div>
    )
  }
}

ProfileSource.defaultProps = {
  source: ''
}

export default ProfileSource
