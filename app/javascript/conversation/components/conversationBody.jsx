import React from 'react'
import ConversationFooter from './conversationFooter'
import ConversationEndCap from './conversationEndCap'
import ConversationDay from './conversationDay'
import moment from 'moment'

class ConversationBody extends React.Component {
  constructor(props) {
    super(props);
    this._resizeScroller = this._resizeScroller.bind(this);
  }

  render() {
    return (
        <div className='client_body'>
          <div className='client_messages'>
            <ConversationFooter
              contact={this.props.contact}
              conversation={this.props.conversation}
            />
            <div id='messages_container'>
              <div id='msgs_scroller_div' className='message_pane_scroller'>
                <ConversationEndCap contact={this.props.contact} />
                <div className="msgs_holder" id="msgs_div">
                  {this.days().map((day) =>
                    <ConversationDay key={day[0].happened_at} messages={day} day={day[0].happened_at} contact={this.props.contact} />
                  )}
                </div>
              </div>
            </div>
          </div>
        </div>

    )
  }

  componentDidMount() {
    $(window).resize(this._resizeScroller);
    this._resizeScroller();
  }

  days() {
    return R.groupWith(this._sameDay, this.props.parts);
  }

  _sameDay(first, second) {
    let firstMoment = moment(first.happened_at);
    let secondMoment = moment(second.happened_at);

    return firstMoment.isSame(secondMoment, 'day');
  }

  _setChannelsScrollerHeight(window_h) {
    let top_nav_offset = $('nav.navbar.top').outerHeight();
    let top_subNav_offset = $(".team_menu").outerHeight();
    let height = window_h - top_subNav_offset - top_nav_offset;
    $('#notes_scroller').css('height', height);
  }

  _resizeScroller() {
    let cached_wh = $(window).height();

    let msgs_scroller_y = $(".client_body").offset().top;
    let footer_outer_h = $(".footer").outerHeight();

    let msgs_scroller_height = cached_wh - msgs_scroller_y - footer_outer_h;
    $('#msgs_scroller_div').css('height', msgs_scroller_height);

    let end_div = $("#end_div");
    let end_display_padder = $("#end_display_padder");
    end_div.css("height", "");
    end_display_padder.css("height", "");
    let end_display_div = $("#end_display_div");
    let h = end_display_div.outerHeight();
    let allowed_h;
    allowed_h = $('#msgs_scroller_div')[0].scrollHeight - $('#msgs_div').outerHeight();
    allowed_h -= 32;
    if (allowed_h > h) {
      end_display_padder.css("height", allowed_h - h);
    }
    end_div.height(allowed_h);

    let flex_contents_height = cached_wh - msgs_scroller_y;
    $("#flex_contents > .panel").css("height", flex_contents_height);
    this._setChannelsScrollerHeight(cached_wh);
  }
}

export default ConversationBody
