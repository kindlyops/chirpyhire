import React from 'react'

const Header = props => (
  <div className={props.className + ' ch--Header'}>
    {props.children}
  </div>
)

Header.defaultProps = {
  className: ''
}

export default Header
