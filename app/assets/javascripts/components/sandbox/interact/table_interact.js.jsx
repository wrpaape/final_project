/* globals React */
'use strict';

var TableInteract = React.createClass({
  getInitialState: function () {
    return {
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
      showHead: false,
      loading: false
    };
  },
  render: function () {
    var url = this.props.url;
    var rows = [];
    var data = this.state.data;
    var loadingClassName = 'loading-' + this.state.loading +' db-table';
    var tableClassName = 'table interact lighten-' + this.state.loading;
    var showHead = this.state.showHead;


    if (showHead) {
      data.forEach(function (obj) {
        rows.push(<RowInteract key={ 'row-' + obj.id } obj={ obj } url={ url } parent={ this } />);
      }.bind(this));
    } else {
      data.forEach(function (obj, i) {
        rows.push(<tr key={ 'misc-row-' + i }><td key={ 'misc-col-' + i }>{ JSON.stringify(obj) }</td></tr>);
      });
    }

    return(
      <div className='container-interact'>
        <section>
          <table className={ tableClassName }>
            <img src='/assets/pig_glow.gif' className={ loadingClassName } />
            <TableHeadInteract parent={ this } />
            <tbody>
              {rows}
            </tbody>
          </table>
        </section>
        <div className='row'>
          <div className='col-md-6'>
            <EditorInteract parent={ this } />
          </div>
          <div className='col-md-6'>
            <DisplayResultsInteract parent={ this } />
          </div>
        </div>
      </div>
    );
  }
});
