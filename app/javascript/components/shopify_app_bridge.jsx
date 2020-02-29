import React from 'react'
import { Loading, Provider as AppBridgeProvider, TitleBar } from '@shopify/app-bridge-react'
import createApp from '@shopify/app-bridge';
import { Redirect } from '@shopify/app-bridge/actions'
import enTranslations from '@shopify/polaris/locales/en.json'
import { AppProvider, Page, Card, Button } from '@shopify/polaris'
import { Link } from 'react-router-dom'
import { withRouter } from 'react-router-dom'

function AdapterLink ({ url, ...rest }) {
  return <Link to={url} {...rest} />
}

class ShopifyAppBridge extends React.Component {
  constructor(props) {
    super(props);
  }

  componentDidMount() {
    // console.log(this.props);
    const app = createApp(this.props.config);
    const history = this.props.history;
    app.subscribe(Redirect.ActionType.APP, function(redirectData) {
      console.log("SAB: pushing url"); // For example, '/settings'
      console.log(redirectData.path); // For example, '/settings'
      history.push(redirectData.path)
    });
    // const redirect = Redirect.create(app);
    // redirect.dispatch(Redirect.Action.APP, '/orders');
  }

  render() {
    // const primaryAction = {content: 'Foo', url: '/foo'};
    const secondaryActions = [
      {content: 'Orders', url: '/orders'},
      {content: 'Settings', url: '/settings'},
    ];
    // const actionGroups = [{title: 'Baz', actions: [{content: 'Baz', url: '/baz'}]}];
    var page = "Unknown";
    if (this.props.location.pathname == "/")
      page = "Dashboard";
    if (this.props.location.pathname == "/orders")
      page = "Orders";
    if (this.props.location.pathname == "/settings")
      page = "Settings";
    return (
    <AppBridgeProvider config={this.props.config}>
      <Loading />
      <AppProvider i18n={enTranslations} linkComponent={AdapterLink}>
        <Page>
          <TitleBar 
            title={page}
            // primaryAction={primaryAction}
            secondaryActions={secondaryActions}
            // actionGroups={actionGroups}
          />
          {this.props.children}
        </Page>
      </AppProvider>
    </AppBridgeProvider>
    )
  }
}

export default withRouter(ShopifyAppBridge)
