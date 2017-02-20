window.Forms = window.Forms || {};
Forms.Utils = Forms.Utils || {};

Forms.Utils.nameWithContext = (Lower, prop = "name") => {
  const getDisplayName = (component) => component.displayName || component.name || "Component"

  const buildInputName = (namespaces, name = "") => (
    [ ...namespaces, name ].map((field, index) => ( index === 0 ? field : `[${field}]` )).join("")
  )

  const higher = (props, context) => {
    const replacedProp = buildInputName(context.railsFormNamespaces, props[prop])
    const replacedProps = Object.assign({}, props, { [prop]: replacedProp })
    return <Lower {...replacedProps} />
  }

  higher.displayName = getDisplayName(Lower).replace(/Tag$/, "")
  higher.contextTypes = { railsFormNamespaces: React.PropTypes.arrayOf(React.PropTypes.string) }

  return higher
}

Forms.Utils.whitelistProps = (props, ...omit) => {
  const alwaysOmit = [ "key", "ref", ...omit ]
  const cloned = { ...props }
  alwaysOmit.forEach((key) => delete cloned[key])
  return cloned
}

Forms.Tags = Forms.Tags || {};

Forms.Tags.CheckBoxTag = ({ uncheckedValue = 0, ...props }) => {
  const propsWithDefault = { defaultValue: 0, ...props }

  return (
    <span>
      <Form.Tags.HiddenFieldTag value={uncheckedValue} />
      <input type="checkbox" {...propsWithDefault} />
    </span>
  )
}

Forms.Tags.ColorFieldTag = (props) => (
  <input type="color" {...props} />
)

Forms.Tags.DateFieldTag = (props) => (
  <input type="date" {...props} />
)

Forms.Tags.DatetimeFieldTag = (props) => (
  <input type="datetime" {...props} />
)

Forms.Tags.DatetimeLocalFieldTag = (props) => (
  <input type="datetime-local" {...props} />
)

Forms.Tags.EmailFieldTag = (props) => (
  <input type="email" {...props} />
)

Forms.Tags.HiddenFieldTag = (props) => (
  <input type="hidden" readOnly {...props} />
)

Forms.Tags.LabelTag = (props) => (
  <label {...Forms.Utils.whitelistProps(props)} />
)

Forms.Tags.MonthFieldTag = (props) => (
  <input type="month" {...props} />
)

Forms.Tags.NumberFieldTag = (props) => (
  <input type="number" {...props} />
)

Forms.Tags.PasswordFieldTag = (props) => (
  <input type="password" {...props} />
)

Forms.Tags.RadioTag = (props) => (
  <input type="radio" {...props} />
)

Forms.Tags.RangeFieldTag = (props) => (
  <input type="range" {...props} />
)

Forms.Tags.SearchFieldTag = (props) => (
  <input type="search" {...props} />
)

Forms.Tags.SelectTag = (props) => (
  <select {...Forms.Utils.whitelistProps(props)} />
)

Forms.Tags.SubmitTag = (props) => (
  <input type="submit" {...props} />
)

Forms.Tags.TelephoneFieldTag = (props) => (
  <input type="tel" {...props} />
)

Forms.Tags.TextAreaTag = (props) => (
  <textarea {...Forms.Utils.whitelistProps(props)} />
)

Forms.Tags.TextFieldTag = (props) => (
  <input type="text" {...props} />
)

Forms.Tags.TimeFieldTag = (props) => (
  <input type="time" {...props} />
)

Forms.Tags.UrlFieldTag = (props) => (
  <input type="url" {...props} />
)

Forms.Tags.WeekFieldTag = (props) => (
  <input type="week" {...props} />
)

Forms.Fields = Forms.Fields || {};
Forms.Fields.CheckBox = Forms.Utils.nameWithContext(Forms.Tags.CheckBoxTag)
Forms.Fields.ColorField = Forms.Utils.nameWithContext(Forms.Tags.ColorFieldTag)
Forms.Fields.DateField = Forms.Utils.nameWithContext(Forms.Tags.DateFieldTag)
Forms.Fields.DatetimeField = Forms.Utils.nameWithContext(Forms.Tags.DatetimeFieldTag)
Forms.Fields.DatetimeLocalField = Forms.Utils.nameWithContext(Forms.Tags.DatetimeLocalFieldTag)
Forms.Fields.EmailField = Forms.Utils.nameWithContext(Forms.Tags.EmailFieldTag)
Forms.Fields.HiddenField = Forms.Utils.nameWithContext(Forms.Tags.HiddenFieldTag)
Forms.Fields.Label = Forms.Utils.nameWithContext(Forms.Tags.LabelTag, "htmlFor")
Forms.Fields.MonthField = Forms.Utils.nameWithContext(Forms.Tags.MonthFieldTag)
Forms.Fields.NumberField = Forms.Utils.nameWithContext(Forms.Tags.NumberFieldTag)
Forms.Fields.PasswordField = Forms.Utils.nameWithContext(Forms.Tags.PasswordFieldTag)
Forms.Fields.Radio = Forms.Utils.nameWithContext(Forms.Tags.RadioTag)
Forms.Fields.RangeField = Forms.Utils.nameWithContext(Forms.Tags.RangeFieldTag)
Forms.Fields.SearchField = Forms.Utils.nameWithContext(Forms.Tags.SearchFieldTag)
Forms.Fields.Select = Forms.Utils.nameWithContext(Forms.Tags.SelectTag)
Forms.Fields.Submit = Forms.Utils.nameWithContext(Forms.Tags.SubmitTag)
Forms.Fields.TelephoneField = Forms.Utils.nameWithContext(Forms.Tags.TelephoneFieldTag)
Forms.Fields.TextArea = Forms.Utils.nameWithContext(Forms.Tags.TextAreaTag)
Forms.Fields.TextField = Forms.Utils.nameWithContext(Forms.Tags.TextFieldTag)
Forms.Fields.TimeField = Forms.Utils.nameWithContext(Forms.Tags.TimeFieldTag)
Forms.Fields.UrlField = Forms.Utils.nameWithContext(Forms.Tags.UrlFieldTag)
Forms.Fields.WeekField = Forms.Utils.nameWithContext(Forms.Tags.WeekFieldTag)
Forms.Fields.DestroyField = () => <Forms.Fields.HiddenField name="_destroy" value="1" />

Forms.FormTag = React.createClass({
  propTypes: {
    url: React.PropTypes.string.isRequired,
    method: React.PropTypes.oneOf([ "get", "post", "put", "patch", "delete" ]),
    children: React.PropTypes.node,
  },

  getDefaultProps() {
    return {
      method: "post",
    }
  },

  render() {
    let browserHTTPMethod = "post"
    let fakedHTTPMethod = null

    if (this.props.method === "get") {
      browserHTTPMethod = "get"
    } else if (this.props.method !== "post") {
      fakedHTTPMethod = this.props.method
    }

    const csrfToken = document.querySelector("head meta[name='csrf-token']")

    return (
      <form
        {...Forms.Utils.whitelistProps(this.props, "url", "children")}
        acceptCharset="UTF-8"
        action={this.props.url}
        method={browserHTTPMethod}
        >
        {fakedHTTPMethod && (
          <Forms.Tags.HiddenFieldTag
            name="_method"
            value={fakedHTTPMethod}
            />
        )}
        {csrfToken && (
          <Forms.Tags.HiddenFieldTag
            name="authenticity_token"
            value={csrfToken.content}
            />
        )}
        <Forms.Tags.HiddenFieldTag
          name="utf8"
          value="&#x2713;"
          />
        {this.props.children}
      </form>
    )
  },
})

Forms.FormFor = React.createClass({
  propTypes: {
    name: React.PropTypes.string,
  },

  getDefaultProps() {
    return {
      name: null,
    }
  },

  childContextTypes: {
    railsFormNamespaces: React.PropTypes.arrayOf(React.PropTypes.string),
  },

  getChildContext() {
    return {
      railsFormNamespaces: this.props.name ? [ this.props.name ] : [],
    }
  },

  render() {
    return (
      <Forms.FormTag {...this.props}>
        {this.props.children}
      </Forms.FormTag>
    )
  },
})

Forms.FieldsFor = React.createClass({
  propTypes: {
    name: React.PropTypes.string.isRequired,
  },

  contextTypes: {
    railsFormNamespaces: React.PropTypes.arrayOf(React.PropTypes.string),
  },

  childContextTypes: {
    railsFormNamespaces: React.PropTypes.arrayOf(React.PropTypes.string),
  },

  getDefaultProps() {
    return {
      name: "",
    }
  },

  getChildContext() {
    return {
      railsFormNamespaces: [
        ...this.context.railsFormNamespaces,
        this.props.name,
      ],
    }
  },

  render() {
    return <span>{this.props.children}</span>
  },
})

Forms.ArrayFields = Forms.FieldsFor
Forms.HashFields = Forms.FieldsFor
