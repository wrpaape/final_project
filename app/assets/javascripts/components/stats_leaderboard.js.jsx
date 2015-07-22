/* globals React */
'use strict';

var StatsLeaderboard = React.createClass({
  render: function () {
    var show = this.props.show;
    var raw = this.props.raw;
    var ths = [];
    var tds = [];

    var times = {
      'total query time': raw.time_query_total,
      'shortest query': raw.time_query_min,
      'longest query': raw.time_query_max,
      'average query': raw.time_query_avg
    };

    var units = [' (s)', ' (ms)', ' (μs)'];
    Object.keys(times).forEach(function (key, i) {
      var unit = '';
      var th = key;
      var td = times[th];
      if (td === null) {
        td = 'nil';
      } else if (td === 0) {
        unit += ' (s)';
      } else if (td !== 'N/A' && !isNaN(td)) {
        var n = 0;
        while (td < 1) {
          td *= 1000;
          n++;
        }
        unit += units[n];
        td = Number(td).toPrecision(4);
      }
      ths.push(<th key={ 'stats-th-' + raw.id + '-col-' + i }>{ th + unit }</th>);
      tds.push(<td key={ 'stats-td-' + raw.id + '-col-' + i }>{ td }</td>);
    });

    return (
      <td className={ 'stats-' + show }>
        <table>
          <thead>
            <tr>
              { ths }
            </tr>
          </thead>
          <tbody>
            <tr>
              { tds }
            </tr>
          </tbody>
        </table>
      </td>
    );
  }
});
