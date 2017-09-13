import React from 'react'
import Select from 'react-select'

class ProfileStage extends React.Component {
  constructor(props) {
    super(props)

    this.options = this.options.bind(this);
    this.onChange = this.onChange.bind(this);
  }

  onChange({ value, label }) {
    const data = { 
      _method: 'put', contact: { contact_stage_id: value }
    }
    const config = {
      url: `/contacts/${this.props.contact.id}`,
      data: data,
      type: 'POST',
      method: 'POST',
      dataType: 'text'
    }
    $.ajax(config).then(() => {
      let properties = { 
        name: label, id: value, contact_id: this.props.contact.id 
      };
      
      heap.track('Set Candidate Stage', properties);
    });
  }

  options() {
    return this.props.contact.contact_stages.map(stage => ({ value: stage.id, label: stage.name }));
  }

  render() {
    return (
      <div className='form-group mt-3'>
        <label id='stage' className='col-form-label'><strong>Stage:</strong></label>
        <Select
          id='stage'
          name="contact[contact_stage_id]"
          options={this.options()}
          value={this.props.contact.contact_stage_id}
          onChange={this.onChange}
          clearable={false}
        />
      </div>
    )
  }
}

ProfileStage.defaultProps = {
  contact: {
    contact_stages: [],
    contact_stage_id: ''
  }
}

export default ProfileStage
