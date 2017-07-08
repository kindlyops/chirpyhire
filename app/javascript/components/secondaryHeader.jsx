import React from 'react'

const SecondaryHeader = props => (
  <div className={props.className + ' ch--SecondaryHeader'}>
    {props.children}
  </div>
)

SecondaryHeader.defaultProps = {
  className: ''
}

export default SecondaryHeader
