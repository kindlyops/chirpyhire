import React from 'react'
import { Editor, Plain } from 'slate'

class PlainText extends React.Component {
  constructor(props) {
    super(props);
    
    this.state = {
      state: Plain.deserialize(props.value)
    };
    this.onChange = this.onChange.bind(this);
    this.onDocumentChange = this.onDocumentChange.bind(this);
  }

  componentWillReceiveProps(nextProps) {
    if(nextProps.value !== this.props.value) {
      let state = Plain.deserialize(nextProps.value);
      this.setState({ state: state });
    }
  }

  onChange(state) {
    this.setState({ state: state });
  }

  onDocumentChange(handler) {
    return function(document, state) {
      let value = Plain.serialize(state);
      handler(value);
    }
  }

  render() {
    return(<Editor
      className={this.props.className}
      placeholder={this.props.placeholder}
      state={this.state.state}
      onDocumentChange={this.onDocumentChange(this.props.onDocumentChange)}
      onChange={this.onChange}/>);
  }
}

PlainText.defaultProps = {
  value: '',
  placeholder: 'Enter some text...',
  className: '',
  onDocumentChange: () => {}
}

export default PlainText;
