/* globals React */
'use strict';

var HomePage = React.createClass({
  getInitialState: function() {
    return {
      loggedIn: this.props.loggedIn
    };
  },
  componentDidMount: function() {
    $('#page-cover').removeClass('cursor-progress');
    $(document).ajaxSuccess(function(){
      var loggedIn = this.state.loggedIn;
      $('#modal-sign-up').modal('hide');
      $('#modal-sign-in').modal('hide');
      this.setState({ loggedIn : !loggedIn });
    }.bind(this));
  },
  componentWillUnmount: function() {
    $(document).unbind('ajaxSuccess');
  },
  render: function() {
    var buttons = [];
    var homePage = this;
    var urls = this.props.urls;
    var signOut = urls.signOut;
    var enter = urls.enter;
    var loggedIn = this.state.loggedIn;
    var signUpClass = 'btn btn-primary sign-up-home';
    signUpClass += loggedIn ? '' : ' shine';

    buttons.push(<button key='button-1' id='sign-up' type='button' className={ signUpClass } data-toggle='modal' data-target='.sign-up-form' onClick={ homePage.listenForAjax }>sign up</button>);
    if (loggedIn) {
      buttons.push(<a key='button-2' className='btn btn-primary' onClick={ homePage.clicked }>sign out</a>);
      buttons.push(<a key='button-3' href={ enter } className='btn btn-primary shine'>enter</a>);
    } else {
      buttons.push(<button key='button-2' id='sign-in' className='btn btn-primary shine sign-in-home' data-toggle='modal' data-target='.sign-in-form' onClick={ homePage.listenForAjax }>sign in</button>);
      buttons.push(<a key='button-3' href={ enter } className='btn btn-primary'>guest</a>);
    }

    return(
      <div className='home-container'>
        <div className='home-wrap'>
          <div className='presents-home'>tastyham presents...</div>
          <Img src='/assets/mvc.gif' />
          <div className='title-home'>ActiveRecord Baby</div>
            { buttons }
          <div className='subtitle-home'>where baby Rails devs hone their db:fu</div>
        </div>
      </div>
    );
  },
  clicked: function() {
    $.ajax({
        url: this.props.urls.signOut,
        type: 'DELETE',
        beforeSend: function(xhr) {xhr.setRequestHeader('X-CSRF-Token', $('meta[name="csrf-token"]').attr('content'))},
        success: function() {

        }.bind(this)
    });
  }
});
