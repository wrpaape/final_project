/* globals React */
'use strict';

var TableInteract = React.createClass({
  getInitialState: function () {
    return {
      loggedIn: this.props.loggedIn,
      data: this.props.data,
      results: {
        'isCorrect': false,
        'numQueries': 0,
        'solCharCount': 0,
        'times': {
          'timeExecTotal': 'N/A',
          'timeQueryTotal': 'N/A',
          'timeQueryMin': 'N/A',
          'timeQueryMax': 'N/A',
          'timeQueryAvg': 'N/A',
        }
      },
      loading: false,
      newman: false,
      newmanLevel: 1,
      opacityLevel: 0
    };
  },
  render: function () {
    var switchTable = this.props.parent;
    var url = this.props.url;
    var loggedIn = this.state.loggedIn;
    var data = this.state.data;
    var loading = this.state.loading;
    var loadingClassName = 'loading-' + loading +' db-table interact';
    var tableClassName = 'table interact lighten-' + loading;
    var newmanClassName = 'newman-' + this.state.newman + ' opacity-' + this.state.opacityLevel;
    var timeoutLimit = 5;
    var objectLimit = 5000;
    var charLimit = 10000;
    var keys = Object.keys(data);

    if (typeof(data[keys[0]]) === 'string' && data[keys[0]].search(/(Timeout::Error: execution expired)/g) >= 0) {
      data.unshift('pls have your code execute in ' + timeoutLimit + ' s or less');
    } else if (keys.length >= objectLimit) {
      data = ['object length: ' + keys.length, 'pls limit your objects to ' + objectLimit + ' elements or less'];
    } else {
      for (var i = 0; i < keys.length; i++) {
        if (data[keys[i]].length >= charLimit) {
          data = ['string length: ' + data[keys[i]].length, 'pls limit your strings to ' + charLimit + ' characters or less'];
          break;
        }
      }
    }

    var showHead = false;
    var firstIsHash = Object.prototype.toString.call(data[0]) === '[object Object]';
    if (firstIsHash) {
      var firstKeys = Object.keys(data[0]);
      showHead = true;
      var keysMatch = true;
      data.forEach(function(obj) {
        if (keysMatch) {
          firstKeys.forEach(function(key) {
            if (!(key in obj)) {
              showHead = false;
              return showHead;
            }
          });
        }
      });
    }


    var rows = [];
    if (showHead) {
      data.forEach(function(obj, i) {
        rows.push(<RowInteract key={ 'row-' + i } obj={ obj } url={ url } firstKeys={ firstKeys } grandparent={ switchTable } parent={ this } />);
      }.bind(this));
    } else {
      data.forEach(function(obj, i) {
        rows.push(<tr key={ 'misc-row-' + i }><td key={ 'misc-col-' + i } className='td'>{ JSON.stringify(obj) }</td></tr>);
      });
      rows.push(<tr key={ 'misc-row-empty' }><td key={ 'misc-col-empty' } className='td'></td></tr>);
    }

    return(
      <div className='container-interact'>
        <section>
          <table className={ tableClassName }>
            <TableHeadInteract parent={ this } show={ showHead } />
            <tbody>
              { rows }
            </tbody>
          </table>
        </section>
        <div className='sticky-footer sticky-footer-interact'>
          <div className='editor'>
            <EditorInteract parent={ this } />
          </div>
          <div className='results-wrap'>
            <Img src={ '/assets/newman' + this.state.newmanLevel + '.gif' } className={ newmanClassName } />
            <DisplayResultsInteract parent={ this } showCorrect={ false } loggedIn={ loggedIn } />
          </div>
        </div>
      </div>
    );
  }
});
