import Geosuggest from 'react-geosuggest'

export class renderGeosuggest extends React.Component {
  componentWillReceiveProps(nextProps) {
    if(this.props.input.value !== nextProps.input.value) {
      this.refs.geosuggest.update(nextProps.input.value)
    }
  }

  render() {
    const {input, label, ...custom} = this.props
    return (
      <Geosuggest 
        ref="geosuggest"
        initialValue={input.value}
        onSuggestSelect={(suggest) => input.onChange(suggest)}
        {...custom}
      />
    )
  }
}
