import React from 'react'

const Main = props => (
  <div className={props.className + ' ch--main'}>
    {props.children}
  </div>
)

Main.defaultProps = {
  className: ''
}

export default Main
