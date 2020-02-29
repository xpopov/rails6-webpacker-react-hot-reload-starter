import { hot } from 'react-hot-loader/root'
import React, { Component } from 'react'
import { Navbar, Nav, Form, FormControl, Button, NavItem } from 'react-bootstrap'
import { Switch, Route, Link, withRouter } from 'react-router-dom'
// import { ConnectedRouter } from 'connected-react-router'
import { Page } from '@shopify/polaris'

import DashboardPage from '../pages/dashboard'
import OrdersPage from '../pages/orders'
import SettingsPage from '../pages/settings'

class Navigation extends Component {
  render() {
    return (
      <div>
        <div>
          <Navbar bg="dark" variant="dark">
            <Navbar.Brand as={Link} to="/" >Up-Styled</Navbar.Brand>
            <Navbar.Collapse>
              <Nav className="mr-auto">
                <NavItem eventkey={1} href="/orders" 
                  className={this.props.location.pathname == "/orders" ? "active" : null}>
                  <Nav.Link as={Link} to="/orders" >Orders</Nav.Link>
                </NavItem>
                <NavItem eventkey={1} href="/settings" 
                  className={this.props.location.pathname == "/settings" ? "active" : null}>
                  <Nav.Link as={Link} to="/settings" >Settings</Nav.Link>
                </NavItem>
              </Nav>
              {/* <Form inline>
                <FormControl type="text" placeholder="Search" className="mr-sm-2" />
                <Button variant="outline-success">Search</Button>
              </Form> */}
            </Navbar.Collapse>
          </Navbar>
        </div>
        <div>
          <Switch>
            <Route exact path='/' component={DashboardPage} />
            <Route exact path='/orders' component={OrdersPage} />
            <Route exact path='/settings' component={SettingsPage} />
            <Route render={function () {
              return <Page title="Page not found"></Page>
            }} />
          </Switch>
        </div>
      </div>
    );
  }
}

export default hot(withRouter(Navigation))
