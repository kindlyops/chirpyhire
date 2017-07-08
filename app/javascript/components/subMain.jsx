import React from 'react'

const SubMain = props => (
  <div className={props.className + ' ch--sub-main'}>
    {props.children}
  </div>
)

SubMain.defaultProps = {
  className: ''
}

export default SubMain
