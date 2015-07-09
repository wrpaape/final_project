/* globals React */
'use strict';

var ModelSchemaInteract = React.createClass({
  getInitialState: function () {
    return {
      show: false
    };
  },
  render: function() {
    var show = this.state.show;
    var table = this.props.grandparent;
    var data = table.state.data;
    var schema = data.schema;
    var paddedSchema = padSchema(schema);

    if (show) {
      return(
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-default show-hide'>Hide Schema</div>
          <section className='schema'>
            { paddedSchema }
          </section>
        </div>
      );
    } else {
      return(
        <div className='row center'>
          <div onClick={ this.clicked.bind(this, show) } className='btn btn-primary show-hide'>Show Schema</div>
        </div>
      );
    };
    function padSchema(schema) {
      var paddedSchema = [];
      var lines = schema.split('\n');
      for (var i = 1; i <= lines.length - 2; i++) {
        if (i === 1 || i === lines.length - 2) {
          paddedSchema.push(<span key={ 'schema-line-' + i }>{ lines[i] }<br /></span>);
        } else {
          paddedSchema.push(<span key={ 'schema-line-' + i }><span className='pad'>..</span>{ lines[i] }<br /></span>);
        }
      }
      return paddedSchema;
    }
  },
  clicked: function(show) {
    this.setState({ show: !show });
  }
});
