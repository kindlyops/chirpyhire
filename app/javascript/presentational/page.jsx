import React from 'react'

const Page = props => (
  <div className={props.className + ' ch--Page'}>
    {props.children}
  </div>
)

Page.defaultProps = {
  className: ''
}

export default Page
