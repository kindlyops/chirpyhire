import React from 'react'

class ConversationEndCap extends React.Component {
  render() {
    return (
      <div id='end_div'>
        <div id="end_display_div">
          <div id="end_display_padder" style={{height: '21px'}}></div>
          <div id="end_display_meta">
            <div id="im_meta">
              <div className="dm_badge d-flex align-items-center">
                <div className={`author_image thumb_72 second ${this.props.contact.hero_pattern_classes}`}></div>
                <p className="dm_badge_meta">
                  <span className="member_real_name">
                    <strong>{this.props.contact.handle}</strong>
                  </span>
                </p>
              </div>
              <p className="dm_explanation mx-auto text-left clearfix">This is the very beginning of your relationship with <strong>{this.props.contact.handle}.</strong></p>
            </div>
          </div>
        </div>
      </div>
    )
  }
}

export default ConversationEndCap
