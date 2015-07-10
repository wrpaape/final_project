/* globals React */
'use strict';

var ModelMigrationInspect = React.createClass({
  getInitialState: function () {
    return {
      show: false
    };
  },
  render: function() {
    var show = this.state.show;
    var table = this.props.grandparent;
    var data = table.state.data;
    var migrationFile = data.migrationFile;
    var paddedMigrationFile = padMigration(migrationFile);

    if (show) {
      return(
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-default show-hide'>Hide Migration</div>
          <section className='migration'>
            { paddedMigrationFile }
          </section>
        </div>
      );
    } else {
      return(
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-primary show-hide'>Show Migration</div>
        </div>
      );
    };
    function padMigration(migrationFile) {
      var paddedMigrationFile = [];
      var lines = migrationFile.split('\n');
      for (var i = 1; i <= lines.length - 1; i++) {
        var padIndex = lines[i].search(/[a-z]/);
        var pad = new Array(padIndex + 1).join('~');
        var line = lines[i].slice(padIndex);
        paddedMigrationFile.push(<span key={ 'migration-line-' + i }><span className='pad'>{ pad }</span><span className='migration-line'>{ line }</span><br /></span>);
      }
      return paddedMigrationFile;
    }
  },
  clicked: function(show) {
    this.setState({ show: !show })
  }
});
