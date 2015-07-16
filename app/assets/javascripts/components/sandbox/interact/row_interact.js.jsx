/* globals React */
'use strict';

var RowInteract = React.createClass({
  render: function () {
    var cols = [];
    var table = this.props.parent;
    var obj = this.props.obj;
    var keys = Object.keys(obj);

    for (var i = 0; i < keys.length; i++) {
      var className = i % 2 === 0 ? 'darker td' : 'lighter td';
      var val = obj[keys[i]];

      if (val === null) {
        val = 'nil';
      }

      cols.push(<td id={ 'row-' + obj.id + '-col-' + i } key={ 'row-' + obj.id + '-col-' + i } className={ className } onMouseOver={ this.mouseOver.bind(this, val, obj, i) } onMouseOut={ this.mouseOut.bind(this, val, obj, i) }>{ val }</td>);
    }
    return (
      <tr id={ obj.id } className={ className }>
        { cols }
      </tr>
    );
  },
  mouseOver: function(val, obj, i) {
    var isDatetime = val.toString().match(/^(\d{4})-(\d{2})-(\d{2})([a-zA-Z])(\d{2}):(\d{2}):(\d{2})/);
    if (isDatetime !== null) {
      var valFormatted = (moment(val).format('MM/DD/YYYY hh:mm a'));
      var idSelector = '#row-' + obj.id + '-col-' + i;
      $(idSelector).html(valFormatted);
      $(idSelector).addClass("formatted-time");
    }
  },
  mouseOut: function(val, obj, i) {
    var idSelector = '#row-' + obj.id + '-col-' + i;
    $(idSelector).html(val);
    $(idSelector).removeClass("formatted-time");
  }
});
