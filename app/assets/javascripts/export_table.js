(function ($) {
  'use strict';
  var sprintf = $.fn.bootstrapTable.utils.sprintf;

  $.extend($.fn.bootstrapTable.defaults, {
    showExport: false
  });

  var BootstrapTable = $.fn.bootstrapTable.Constructor,
  _initToolbar = BootstrapTable.prototype.initToolbar;

  var calculateObjectValue = function (self, name, args, defaultValue) {
      var func = name;

      if (typeof name === 'string') {
          // support obj.func1.func2
          var names = name.split('.');

          if (names.length > 1) {
              func = window;
              $.each(names, function (i, f) {
                  func = func[f];
              });
          } else {
              func = window[name];
          }
      }
      if (typeof func === 'object') {
          return func;
      }
      if (typeof func === 'function') {
          return func.apply(self, args || []);
      }
      if (!func && typeof name === 'string' && sprintf.apply(this, [name].concat(args))) {
          return sprintf.apply(this, [name].concat(args));
      }
      return defaultValue;
  };

  BootstrapTable.prototype.queryParams = function() {
    var that = this,
        data = {},
        params = {
            searchText: this.searchText,
            sortName: this.options.sortName,
            sortOrder: this.options.sortOrder
        };

    if (this.options.pagination) {
        params.pageSize = this.options.pageSize === this.options.formatAllRows() ?
            this.options.totalRows : this.options.pageSize;
        params.pageNumber = this.options.pageNumber;
    }

    if (!this.options.url && !this.options.ajax) {
        return '';
    }

    if (this.options.queryParamsType === 'limit') {
        params = {
            search: params.searchText,
            sort: params.sortName,
            order: params.sortOrder
        };

        if (this.options.pagination) {
            params.offset = this.options.pageSize === this.options.formatAllRows() ?
                0 : this.options.pageSize * (this.options.pageNumber - 1);
            params.limit = this.options.pageSize === this.options.formatAllRows() ?
                this.options.totalRows : this.options.pageSize;
        }
    }

    if (!($.isEmptyObject(this.filterColumnsPartial))) {
        params.filter = JSON.stringify(this.filterColumnsPartial, null);
    }

    data = calculateObjectValue(this.options, this.options.queryParams, [params], data);
    return R.pickBy(R.compose(R.not, R.isNil), data);
  };

  BootstrapTable.prototype.initToolbar = function () {
    this.showToolbar = this.options.showExport;

    _initToolbar.apply(this, Array.prototype.slice.apply(arguments));

    if (this.options.showExport) {
      var that = this,
      $btnGroup = this.$toolbar.find('>.btn-group'),
      $export = $btnGroup.find('div.export:not([loaded])');

      if (!$export.length) {
        var exportButton = function(type, title) {
          return ['<button role="button" class="export-', type, ' btn ml-2',
          sprintf(' btn-%s', this.options.buttonsClass),
          sprintf(' btn-%s', this.options.iconSize),
          '" aria-label="export-', type, ' type" ',
          'title="', title, '" ',
          'type="button">',
          '<span class="mr-2">', title, '</span>',
          sprintf('<i class="%s %s"></i> ', this.options.iconsPrefix, this.options.icons.export),
          '</button>'].join('');
        }

        $export = $([
          '<div class="export btn-group">',
          exportButton.bind(this)('selected', 'Export Selected'),
          exportButton.bind(this)('all', 'Export All'),
          '</div>'].join('')).appendTo($btnGroup);

        $export.find('.export-selected').click(function(e) {
          e.preventDefault();
          var ids = R.pluck('id')(that.getAllSelections());
          var params = R.merge(that.queryParams(), { 'id[]': ids });
          $.ajax({
            headers: {
              Accept : "text/csv;charset=utf-8",
              "Content-Type": "text/csv;charset=utf-8"
            },
            url: '/candidates.csv',
            data: params,
            dataType: 'text',
            success: function(data) {
              var encodedUri = encodeURI('data:text/csv;charset=utf-8,' + data);
              var link = document.createElement('a');
              link.setAttribute('href', encodedUri);
              link.setAttribute('download', 'candidates-'+ Date.now() +'.csv');
              document.body.appendChild(link);
              link.click();
            }
          });
        });

        $export.find('.export-all').click(function(e) {
          e.preventDefault();
          var filterWithKeys = function(pred, obj) {
            return R.pipe(
              R.toPairs,
              R.filter(R.apply(pred)),
              R.fromPairs
            )(obj);
          }

          var notLimitOrOffset = function(key) {
            return key !== 'limit' && key !== 'offset';
          }

          var params = filterWithKeys(notLimitOrOffset, that.queryParams());
          window.location.href = '/candidates.csv?' + $.param(params);
        });
      }
    }
  };
})(jQuery);
