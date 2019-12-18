import React from 'react'
import PropTypes from 'prop-types';
import { Jumbotron, Button } from 'react-bootstrap'

const Hello = props => (
  <>
    <Jumbotron fluid={true}>
    <h1>Hello, {props.name}!</h1>
    <p>
      This is a simple hero unit, a simple jumbotron-style component for calling
      extra attention to featured content or information.
    </p>
    <p>
      <Button variant="primary">Learn more</Button>
    </p>
    </Jumbotron>
  </>
)

Hello.defaultProps = {
  name: 'David'
}

Hello.propTypes = {
  name: PropTypes.string
}

export default Hello
