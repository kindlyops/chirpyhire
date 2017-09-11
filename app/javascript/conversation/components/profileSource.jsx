import React from 'react'

class ProfileSource extends React.Component {
  constructor(props) {
    super(props)

    this.onChange = this.onChange.bind(this);
    this.sourceChange = _.debounce(this.sourceChange, 400);
  }

  componentWillReceiveProps(nextProps) {
    if (nextProps.contact.source !== this.props.contact.source) {
      this.setState({ source: nextProps.contact.source });
    }
  }

  onChange(event) {
    event.persist();
    this.setState({ source: event.target.value });
    this.sourceChange(event);
  }

  sourceChange(event) {
    const params = {
      _method: 'put',
      contact: { source: event.target.value }
    };

    const config = {
      url: `/contacts/${this.props.contact.id}`,
      data: params,
      type: 'POST',
      method: 'POST',
      dataType: 'text'
    }

    $.ajax(config);
  }

  render() {
    return (
      <div className='form-group'>
        <input className='form-control' placeholder='CraigsList, Facebook, Referral...' type="text" name="contact[source]" value={this.props.contact.source} onChange={this.onChange} />
      </div>
    )
  }
}

ProfileSource.defaultProps = {
  contact: {
    source: ''
  }
}

export default ProfileSource
