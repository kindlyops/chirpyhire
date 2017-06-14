import React from 'react';
import PropTypes from 'prop-types';

class PageProxy {
  constructor(options, page, last) {
    this.options = options;
    this.page = page;
    this.last = last;
  }

  number() {
    return this.page;
  }

  isCurrent() {
    return this.page === this.options.current_page;
  }

  isFirst() {
    return this.page === 1;
  }

  isLast() {
    return this.page === this.options.total_pages;
  }

  isPrev() {
    return this.page === this.options.current_page - 1;
  }

  isNext() {
    return this.page === this.options.current_page + 1;
  }

  rel() {
    if(this.isNext()) {
      return 'next'
    } else if (this.isPrev()) {
      return 'prev'
    }
  }

  withinLeftOuter() {
    return this.page <= this.options.left;
  }

  withinRightOuter() {
    return this.options.total_pages - this.page < this.options.right;
  }

  isInsideWindow() {
    return Math.abs(this.options.current_page - this.page) <= this.options.window;
  }

  isSingleGap() {
    return ((this.page === this.options.current_page - this.options.window - 1) && 
      (this.page === this.options.left + 1)) || 
    ((this.page === this.options.current_page + this.options.window + 1) &&
    (this.page === this.options.total_pages - this.options.right))
  }

  isOutOfRange() {
    return this.page > this.options.total_pages;
  }

  wasTruncated() {
    this.last.type === 'Gap';
  }

  displayTag() {
    return (
      this.withinLeftOuter() || 
      this.withinRightOuter() || 
      this.isInsideWindow() || 
      isSingleGap()
    );
  }

  add(page) {
    return this.number() + page.number();
  }

  subtract(page) {
    return this.number() - page.number();
  }

  toString() {
    return this.number().toString();
  }
}

class Pagination extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      default_per_page: 25,
      max_per_page: null,
      max_pages: null,
      window: 4,
      outer_window: 0,
      left: 0,
      right: 0,
      params_on_first_page: false
    }
  }

  windowOptions() {
    return {
      window: this.state.window,
      left: this.state.left === 0 ? this.state.outer_window : this.state.left,
      right: this.state.right === 0 ? this.state.outer_window : this.state.right
    }
  }

  firstPage() {
    if(this.props.current_page !== 1) {
      return (
        <li className="page-item">
          <a className='page-link' href='#' rel='first' onClick={() => this.props.onPaginationClick(1)}>&laquo; First</a>
        </li>
      )
    }
  }

  previousPage() {
    if(this.props.current_page !== 1) {
      return (
        <li className="page-item">
          <a className='page-link' href='#' rel='previous' onClick={() => this.props.onPaginationClick(this.props.current_page - 1)}>&lsaquo; Prev</a>
        </li>
      )
    }
  }

  pages() {
    const options = this.windowOptions();
    let left_window_plus_one = R.range(1, options.left + 2);
    let right_window_plus_one = R.range(options.total_pages - options.right, options.total_pages + 1);
    let inside_window_plus_each_sides = R.range(options.current_page - options.window - 1, options.current_page + options.window + 2);

    R.reject(
      (page) => ((page < 1) || (page > options.total_pages)), 
      R.sort(
        (a, b) => (a - b), 
        R.union(
          left_window_plus_one, 
          inside_window_plus_each_sides, 
          right_window_plus_one
        )
      )
    )
  }

  nextPage() {
    if(this.props.current_page !== this.props.total_pages) {
      return (
        <li className="page-item">
          <a className='page-link' href='#' rel='next' onClick={() => this.props.onPaginationClick(this.props.current_page + 1)}>Next &rsaquo;</a>
        </li>
      )
    }
  }

  lastPage() {
    if(this.props.current_page !== this.props.total_pages) {
      return (
        <li className="page-item">
          <a className='page-link' href='#' rel='last' onClick={() => this.props.onPaginationClick(this.props.total_pages)}>Last &raquo;</a>
        </li>
      )
    }
  }

  render() {

    return (
      <nav>
        <ul className='pagination'>
          {this.firstPage()}
          {' '}
          {this.previousPage()}
          {' '}
          {this.pages()}
          {' '}
          {this.nextPage()}
          {' '}
          {this.lastPage()}
        </ul>
      </nav>
    );
  }
}

Pagination.propTypes = {
  current_page: PropTypes.number.isRequired,
  total_pages:  PropTypes.number.isRequired,
  total_count:  PropTypes.number.isRequired
};

export default Pagination
